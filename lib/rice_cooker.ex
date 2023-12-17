defmodule RiceCooker do
  alias RiceCooker.Tui
  alias RiceCooker.Core.Model

  defp get_rice_cooker, do: %Model.RiceCooker{}

  def main(_) do
    get_rice_cooker()
    |> show_menu()
  end

  defp show_menu(cooker) do
    menu = Tui.Readline.select(["Cook", "Exit"])
    run(menu, cooker)
  end

  defp run("Cook", cooker) do
    IO.puts("cook")
    show_menu(cooker)
  end

  defp run("Exit", _), do: IO.puts("Done!")

  defp run(_, cooker) do
    show_menu(cooker)
  end
end
