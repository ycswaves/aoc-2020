defmodule Boarding do
  @input_file_path Path.expand('./input.txt', __DIR__)

  def load() do
    File.read!(@input_file_path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def process(code_list) do
    code_list
    |> Enum.map(fn code -> {get_row(code), get_col(code)} end)
    |> Enum.map(&get_seat_id/1)
    |> Enum.sort()
    |> Enum.reverse()
  end

  def locate_missing([]), do: nil
  def locate_missing([id1, id2 | _rest]) when id1 - id2 > 1, do: id1 - 1
  def locate_missing([_id | rest]), do: locate_missing(rest)

  def locate_missing_alt(code_list) do
    first = List.first(code_list)
    last = List.last(code_list)

    (Enum.count(code_list) + 1) / 2 * (first + last) - Enum.sum(code_list)
  end

  def get_seat_id({row, col}), do: row * 8 + col

  def get_row(seat_code) do
    seat_code
    |> Enum.take(7)
    |> locate(0, 127)
  end

  def get_col(seat_code) do
    seat_code
    |> Enum.take(-3)
    |> locate(0, 7)
  end

  defp locate(["L"], lower, _upper), do: lower

  defp locate(["L" | rest], lower, upper) do
    new_upper = floor((lower + upper) / 2)
    locate(rest, lower, new_upper)
  end

  defp locate(["R"], _lower, upper), do: upper

  defp locate(["R" | rest], lower, upper) do
    new_lower = ceil((lower + upper) / 2)
    locate(rest, new_lower, upper)
  end

  defp locate(["F" | rest], lower, upper) do
    locate(["L" | rest], lower, upper)
  end

  defp locate(["B" | rest], lower, upper) do
    locate(["R" | rest], lower, upper)
  end
end
