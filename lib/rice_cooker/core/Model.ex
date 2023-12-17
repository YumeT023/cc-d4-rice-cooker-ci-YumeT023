defmodule RiceCooker.Core.Model.RiceCooker do
  alias RiceCooker.Core.Model.RiceCooker

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

  def set_is_plugged(self = %RiceCooker{}, is_plugged), do: %{self | is_plugged: is_plugged}

  def set_is_lid_open(self = %RiceCooker{}, is_opened), do: %{self | is_lid_open: is_opened}

  def add_rice_cup(self = %RiceCooker{}, cup \\ 0) when can_put_in_inner_pot(self),
    do: %{self | rice_cup: self[:rice_cup] + cup}

  def add_water_cup(self = %RiceCooker{}, cup \\ 0) when can_put_in_inner_pot(self),
    do: %{self | water_cup: self[:water_cup] + cup}

  def get_ready_to_serve_food(self = %RiceCooker{is_lid_open: false}) do
    IO.puts("Consider opening the lid of the inner pot first")
    self
  end

  def get_ready_to_serve_food(self = %RiceCooker{is_ready: false}) do
    IO.puts("Food hasn't been cooked yet")
    self
  end

  def get_ready_to_serve_food(self = %RiceCooker{}),
    do: %{self | is_ready: false, rice_cup: 0, water_cup: 0}

  def cook(self = %RiceCooker{is_lid_open: true}) do
    IO.puts("Ensure the inner pot lid is closed")
    self
  end

  def cook(self = %RiceCooker{is_plugged: false}) do
    IO.puts("Plug the rice cooker to start cooking")
    self
  end

  def cook(self = %RiceCooker{}) when self.rice_cup > 0 and self.water_cup > 0 do
    IO.puts("Inner pot must contains rice and water before starting to cook")
    self
  end

  def cook(self) do
    milliseconds = get_estimated_cooking_duration_seconds(self) * 1000
    :timer.sleep(milliseconds)
    IO.puts("Food is ready-to-serve")
    %RiceCooker{self | is_ready: true}
  end

  defp get_estimated_cooking_duration_seconds(self = %RiceCooker{}),
    do: self.rice_cup * @seconds_per_cup
end
