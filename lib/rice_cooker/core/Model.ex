defmodule RiceCooker.Core.Model.RiceCooker do
  @default_capacity 20

  defstruct capacity: @default_capacity,
            is_lid_open: false,
            is_plugged: false,
            is_ready: false,
            water_cup: 0,
            rice_cup: 0
end
