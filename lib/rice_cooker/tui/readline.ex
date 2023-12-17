defmodule RiceCooker.Tui.Readline do
  def select(list) do
    IO.puts("\n")

    list
    |> Enum.with_index()
    |> Enum.each(fn {label, idx} ->
      IO.puts("#{idx + 1} - #{label}")
    end)

    visual_idx = int("Select menu")
    Enum.at(list, visual_idx - 1)
  end

  defp prompt(query, default) do
    case IO.gets(format_query(query)) do
      {:error, _} -> default
      :eof -> default
      data -> data |> String.trim()
    end
  end

  def int(query), do: prompt(query, "0") |> String.to_integer()

  def str(query), do: prompt(query, "")

  defp format_query(query), do: "#{query} >\n"
end
