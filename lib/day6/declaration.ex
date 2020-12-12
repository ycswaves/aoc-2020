defmodule Declaration do
  @input_file_path Path.expand('./input.txt', __DIR__)

  def load() do
    File.read!(@input_file_path)
    |> String.split("\n\n", trim: true)
  end

  def count_all_union do
    load()
    |> Enum.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&get_freq_for_group/1)
    |> Enum.map(&Map.keys/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  def count_unanimous_answer do
    load()
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&count_overlapping_for_group/1)
    |> Enum.sum()
  end

  defp get_freq_for_group(group_data_str) do
    group_data_str
    |> String.graphemes()
    |> Enum.frequencies()
  end

  defp count_overlapping_for_group(group_data_list) do
    person_count = Enum.count(group_data_list)

    group_data_list
    |> Enum.join()
    |> get_freq_for_group
    |> Map.to_list()
    |> Enum.filter(fn {_, count} -> count == person_count end)
    |> Enum.count()
  end
end
