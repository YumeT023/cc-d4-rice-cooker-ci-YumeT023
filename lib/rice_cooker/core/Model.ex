defmodule RiceCooker.Core.Model.RiceCooker do
  alias RiceCooker.Core.Model.RiceCooker
  @default_capacity 20

  defstruct capacity: @default_capacity,
            is_lid_open: false,
            is_plugged: false,
            is_ready: false,
            water_cup: 0,
            rice_cup: 0

  def set_is_plugged(self, is_plugged), do: %{self | is_plugged: is_plugged}

  def set_is_lid_open(self, is_opened), do: %{self | is_lid_open: is_opened}

  def add_rice_cup(self, cup \\ 0), do: %{self | rice_cup: self[:rice_cup] + cup}

  def add_water_cup(self, cup \\ 0), do: %{self | water_cup: self[:water_cup] + cup}

  def get_ready_to_serve_food(self = %RiceCooker{is_lid_open: false}) do
    IO.puts("Consider opening the lid of the inner pot first")
    self
  end

  def get_ready_to_serve_food(self = %RiceCooker{}),
    do: %{self | is_ready: false, rice_cup: 0, water_cup: 0}
end
