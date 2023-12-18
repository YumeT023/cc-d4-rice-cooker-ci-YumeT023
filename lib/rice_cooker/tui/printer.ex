defmodule RiceCooker.Tui.Printer do
  @info "INFO"
  @recommendation "RECOMMENDATION"
  @warning "WARNING"

  def info(str), do: print_level(@info, str)
  def recommendation(str), do: print_level(@recommendation, str)
  def warning(str), do: print_level(@warning, str)

  defp print_level(level, str), do: IO.puts "[#{level}]: #{str}"
end
