defmodule RiceCooker.Core.Model do
  defmodule Rc do
    alias RiceCooker.Tui.Printer

    @default_capacity 20
    # simplicity purpose
    @seconds_per_cup 2

    defstruct capacity: @default_capacity,
              is_lid_open: false,
              is_plugged: false,
              is_ready: false,
              water_cup: 0,
              rice_cup: 0

    defguardp can_put_in_inner_pot(self) when self.is_lid_open and not self.is_plugged

    def set_is_plugged(self = %Rc{}, is_plugged), do: %{self | is_plugged: is_plugged}

    def set_is_lid_open(self = %Rc{}, is_opened), do: %{self | is_lid_open: is_opened}

    def add_rice_cup(self, cup \\ 0)

    def add_rice_cup(self = %Rc{is_ready: true}, _) do
      Printer.warning("Couldn't put rice in the pot")
      self
    end

    def add_rice_cup(self = %Rc{}, cup) when can_put_in_inner_pot(self),
      do: %{self | rice_cup: self.rice_cup + cup}

    def add_water_cup(self, cup \\ 0)

    def add_water_cup(self = %Rc{is_ready: true}, _) do
      Printer.warning("Couldn't put water in the pot")
      self
    end

    def add_water_cup(self = %Rc{}, cup) when can_put_in_inner_pot(self),
      do: %{self | water_cup: self.water_cup + cup}

    def get_ready_to_serve_food(self = %Rc{is_lid_open: false}) do
      Printer.info("Consider opening the lid of the inner pot first")
      self
    end

    def get_ready_to_serve_food(self = %Rc{is_ready: false}) do
      Printer.info("Food hasn't been cooked yet")
      self
    end

    def get_ready_to_serve_food(self = %Rc{}) do
      Printer.info("Emptying the inner pot...")
      :timer.sleep(200)
      %{self | is_ready: false, rice_cup: 0, water_cup: 0}
    end

    def cook(self = %Rc{is_lid_open: true}) do
      Printer.warning("Ensure the inner pot lid is closed")
      self
    end

    def cook(self = %Rc{is_plugged: false}) do
      Printer.info("Plug the rice cooker to start cooking")
      self
    end

    def cook(self = %Rc{rice_cup: rice_cup, water_cup: water_cup})
        when rice_cup < 0 or water_cup < 0 do
      Printer.warning("Inner pot must contains rice and water before starting to cook")
      self
    end

    def cook(self = %Rc{is_ready: true}) do
      Printer.info("Food is already ready-to-served")
      self
    end

    def cook(self) do
      milliseconds = get_estimated_cooking_duration_seconds(self) * 1000
      Printer.info("cooking... [estimated_time: #{milliseconds}]")
      :timer.sleep(milliseconds)
      Printer.info("Food is ready-to-serve")
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
