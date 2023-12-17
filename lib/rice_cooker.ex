defmodule RiceCooker do
  alias RiceCooker.Core.Model.Rc
  alias RiceCooker.Core.Model.RcAction
  alias RiceCooker.Tui

  defp get_rice_cooker, do: %Rc{}

  def main(_) do
    get_rice_cooker()
    |> show_menu()
  end

  defp show_menu(cooker = %Rc{}) do
    menu = Tui.Readline.select(RcAction.generate(cooker))
    IO.inspect "res #{menu}"
    run(menu, cooker)
  end

  defp run("State", cooker) do
    IO.inspect(cooker)
    show_menu(cooker)
  end

  defp run("Plug", cooker) do
    show_menu(cooker |> Rc.set_is_plugged(true))
  end

  defp run("Unplug", cooker) do
    show_menu(cooker |> Rc.set_is_plugged(false))
  end

  defp run("Open the lid", cooker) do
    show_menu(cooker |> Rc.set_is_lid_open(true))
  end

  defp run("Close the lid", cooker) do
    show_menu(cooker |> Rc.set_is_lid_open(false))
  end

  defp run("Cook now", cooker) do
    show_menu(cooker |> Rc.cook())
  end

  defp run("Place raw food in the inner pot", cooker) do
    cup = Tui.Readline.int("Rice cup")
    show_menu(cooker |> Rc.add_rice_cup(cup))
  end

  defp run("Add water", cooker) do
    cup = Tui.Readline.int("Water cup")
    show_menu(cooker |> Rc.add_water_cup(cup))
  end

  defp run("Get ready-to-serve food", cooker) do
    show_menu(cooker |> Rc.get_ready_to_serve_food())
  end

  defp run("Exit", _), do: IO.puts("Done!")

  # Re-Display menu on invalid selection
  defp run(_, cooker) do
    show_menu(cooker)
  end
end
