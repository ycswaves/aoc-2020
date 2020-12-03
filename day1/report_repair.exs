defmodule Report do
  @input_file_path Path.expand('./input.txt', __DIR__)

  def report(report_in_list, target_sum) do
    report_in_map = Map.new(report_in_list, &{&1, &1})

    report_in_list
    |> Enum.reduce(-1, calculate(report_in_map, target_sum))
  end

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
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end
end

Report.load_report()
|> Report.report(2020)
|> IO.inspect()

Report.load_report()
|> Report.report_three(2020)
|> IO.inspect()
