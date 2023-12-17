defmodule RiceCooker.Tui.Readline do
  def prompt_menu(menu \\ []) do
    Enum.each(menu, &(&2 <> &1))
    prompt("Select one")
  end

  defp prompt(query), do: IO.gets(format_query(query)) |> String.trim()

  def int(query), do: prompt(query) |> String.to_integer()

  def str(query), do: prompt(query)

  defp format_query(query), do: "#{query} >\n"
end
