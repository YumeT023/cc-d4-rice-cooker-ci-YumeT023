defmodule RiceCooker.Core.Model do
  defmodule Rc do
    @default_capacity 20
    # simplicity purpose
    @seconds_per_cup 5

    defstruct capacity: @default_capacity,
              is_lid_open: false,
              is_plugged: false,
              is_ready: false,
              water_cup: 0,
              rice_cup: 0

    defguardp can_put_in_inner_pot(self) when self.is_lid_open and not self.is_plugged

    def set_is_plugged(self = %Rc{}, is_plugged), do: %{self | is_plugged: is_plugged}

    def set_is_lid_open(self = %Rc{}, is_opened), do: %{self | is_lid_open: is_opened}

    def add_rice_cup(self = %Rc{rice_cup: rice_cup}, cup \\ 0) when can_put_in_inner_pot(self),
      do: %{self | rice_cup: rice_cup + cup}

    def add_water_cup(self = %Rc{water_cup: water_cup}, cup \\ 0) when can_put_in_inner_pot(self),
      do: %{self | water_cup: water_cup + cup}

    def get_ready_to_serve_food(self = %Rc{is_lid_open: false}) do
      IO.puts("Consider opening the lid of the inner pot first")
      self
    end

    def get_ready_to_serve_food(self = %Rc{is_ready: false}) do
      IO.puts("Food hasn't been cooked yet")
      self
    end

    def get_ready_to_serve_food(self = %Rc{}),
      do: %{self | is_ready: false, rice_cup: 0, water_cup: 0}

    def cook(self = %Rc{is_lid_open: true}) do
      IO.puts("Ensure the inner pot lid is closed")
      self
    end

    def cook(self = %Rc{is_plugged: false}) do
      IO.puts("Plug the rice cooker to start cooking")
      self
    end

    def cook(self = %Rc{}) when self.rice_cup > 0 and self.water_cup > 0 do
      IO.puts("Inner pot must contains rice and water before starting to cook")
      self
    end

    def cook(self) do
      milliseconds = get_estimated_cooking_duration_seconds(self) * 1000
      :timer.sleep(milliseconds)
      IO.puts("Food is ready-to-serve")
      %Rc{self | is_ready: true}
    end

    defp get_estimated_cooking_duration_seconds(self = %Rc{}),
      do: self.rice_cup * @seconds_per_cup
  end

  defmodule RcAction do
    alias RiceCooker.Core.Model.Rc

    def generate(rc = %Rc{}) do
      Enum.concat([
        lid_menu(rc),
        plug_menu(rc),
        raw_food_menu(rc),
        cook_menu(rc),
        serve_menu(rc),
        permanent_menu()
      ])
    end

    defp lid_menu(%Rc{is_plugged: true}), do: []
    defp lid_menu(%Rc{is_lid_open: true}), do: ["Close the lid"]
    defp lid_menu(%Rc{is_lid_open: false}), do: ["Open the lid"]

    defp plug_menu(%Rc{is_plugged: true}), do: ["Unplug"]
    defp plug_menu(%Rc{is_plugged: false}), do: ["Plug"]

    defp raw_food_menu(%Rc{is_lid_open: false}), do: []

    defp raw_food_menu(%Rc{is_lid_open: true, is_plugged: false}),
      do: ["Place raw food in the inner pot", "Add water"]

    defp raw_food_menu(_), do: []

    defp cook_menu(%Rc{
           is_lid_open: false,
           is_plugged: true,
           rice_cup: rice_cup,
           water_cup: water_cup
         })
         when rice_cup > 0 and water_cup > 0,
         do: ["Cook now"]

    defp cook_menu(_), do: []

    defp serve_menu(%Rc{is_ready: true, is_plugged: false, is_lid_open: true}),
      do: ["Get the ready-to-serve cook"]

    defp serve_menu(_), do: []

    defp permanent_menu(), do: ["State", "Done"]
  end
end
