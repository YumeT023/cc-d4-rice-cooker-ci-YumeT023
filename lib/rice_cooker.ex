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
    run(menu, cooker)
  end

  defp run("State", cooker) do
    IO.inspect(cooker)
    show_menu(cooker)
  end

  defp run("Plug", cooker) do
    cooker
    |> Rc.set_is_plugged(true)
    |> show_menu()
  end

  defp run("Unplug", cooker) do
    cooker
    |> Rc.set_is_plugged(false)
    |> show_menu()
  end

  defp run("Open the lid", cooker) do
    cooker
    |> Rc.set_is_lid_open(true)
    |> show_menu()
  end

  defp run("Close the lid", cooker) do
    cooker
    |> Rc.set_is_lid_open(false)
    |> show_menu()
  end

  defp run("Cook now", cooker) do
    cooker
    |> Rc.cook()
    |> show_menu()
  end

  defp run("Place raw food in the inner pot", cooker) do
    cup = Tui.Readline.int("Rice cup")

    cooker
    |> Rc.add_rice_cup(cup)
    |> show_menu()
  end

  defp run("Add water", cooker) do
    cup = Tui.Readline.int("Water cup")

    cooker
    |> Rc.add_water_cup(cup)
    |> show_menu()
  end

  defp run("Get the ready-to-serve cook", cooker) do
    cooker
    |> Rc.get_ready_to_serve_food()
    |> show_menu()
  end

  defp run("Done", _), do: IO.puts("Done!")

  # Re-Display menu on invalid selection
  defp run(_, cooker) do
    show_menu(cooker)
  end
end
