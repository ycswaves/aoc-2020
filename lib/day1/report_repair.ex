defmodule Report do
  @moduledoc """
  AOC day 1 tasks
  """

  @input_file_path Path.expand('./input.txt', __DIR__)

  @doc ~S"""
  Part 1: find the two entries that sum to 2020 and multiply them together

  ## Parameters
   - `report_in_list` - report entries in the form of a list
   - `target_sum` - the sum of the pair of numbers we're looking for

  ## Examples
      iex> Report.load_report() |> Report.report(2020)
      252724
  """
  def report(report_in_list, target_sum) do
    report_in_map = Map.new(report_in_list, &{&1, &1})

    report_in_list
    |> Enum.reduce(-1, calculate(report_in_map, target_sum))
  end

  @doc ~S"""
  Part 2: find the product of the three entries that sum to 2020

  ## Parameters
  - `report_in_list` - report entries in the form of a list
  - `target_sum` - the sum of the pair of numbers we're looking for

  ## Examples
      iex> Report.load_report() |> Report.report_three(2020)
      276912720
  """
  def report_three(report_in_list, target_sum) do
    report_in_list
    |> Enum.reduce(-1, fn x, result ->
      two_sum = report(report_in_list, target_sum - x)

      cond do
        result > -1 -> result
        two_sum > -1 -> two_sum * x
        true -> result
      end
    end)
  end

  def calculate(map, target_sum) do
    fn x, result ->
      target = Map.get(map, target_sum - x)

      cond do
        result > -1 -> result
        target -> target * x
        true -> result
      end
    end
  end

  def load_report do
    File.read!(@input_file_path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
