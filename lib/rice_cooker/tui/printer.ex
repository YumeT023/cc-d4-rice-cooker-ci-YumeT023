defmodule RiceCooker.Tui.Printer do
  @info "INFO"
  @recommendation "RECOMMENDATION"
  @warning "WARNING"

  def logo(), do: IO.puts("
   Y88b      / 888 888          e      888b    | Y88b    /
    Y88b    /  888 888         d8b     |Y88b   |  Y88b  /
     Y88b  /   888 888        /Y88b    | Y88b  |   Y88b/
      Y888/    888 888       /  Y88b   |  Y88b |    Y8Y
       Y8/     888 888      /____Y88b  |   Y88b|     Y
        Y      888 888____ /      Y88b |    Y888    /
    ")

  def info(str), do: print_level(@info, str)

  def recommendation(str), do: print_level(@recommendation, str)

  def warning(str), do: print_level(@warning, str)

  defp print_level(level, str), do: IO.puts("[#{level}]: #{str}")
end
