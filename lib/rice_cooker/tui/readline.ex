defmodule RiceCooker.Tui.Readline do
  def select(list) do
    IO.puts "\n"
    list
    |> Enum.with_index()
    |> Enum.each(fn {label, idx} ->
      IO.puts("#{idx + 1} - #{label}")
    end)

    visual_idx = int("Select menu")
    Enum.at(list, visual_idx - 1)
  end

  defp prompt(query), do: IO.gets(format_query(query)) |> String.trim()

  def int(query), do: prompt(query) |> String.to_integer()

  def str(query), do: prompt(query)

  defp format_query(query), do: "#{query} >\n"
end
