defmodule Password do
  @input_file_path Path.expand('./input.txt', __DIR__)

  def validate_filter_by(entry) do
    [range, required_letter, password] = tokenize_rule(entry)

    [min, max] = parse_range(range)

    password_without_required =
      password
      |> String.graphemes()
      |> Enum.reject(&(&1 == required_letter))
      |> Enum.join()

    required_letter_count = String.length(password) - String.length(password_without_required)
    min <= required_letter_count and required_letter_count <= max
  end

  def validate_group_by(entry) do
    [range, required_letter, password] = tokenize_rule(entry)

    try do
      %{^required_letter => count} =
        password
        |> String.graphemes()
        |> Enum.frequencies()

      [min, max] = parse_range(range)
      min <= count and max >= count
    rescue
      _ ->
        false
    end
  end

  def validate_by_new_rule(entry) do
    [range, required_letter, password] = tokenize_rule(entry)

    [pos1, pos2] = parse_range(range)
    is_at_pos1 = String.at(password, pos1 - 1) == required_letter
    is_at_pos2 = String.at(password, pos2 - 1) == required_letter

    is_at_pos1 != is_at_pos2
  end

  defp parse_range(range) do
    range
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  defp tokenize_rule(entry) do
    [range, required_letter, password] = String.split(entry, " ")

    # convert 'a:' to 'a'
    required_letter = String.first(required_letter)
    [range, required_letter, password]
  end

  def load_report do
    File.read!(@input_file_path)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
  end
end

Password.load_report() |> Enum.count(&Password.validate_group_by/1) |> IO.inspect()
Password.load_report() |> Enum.count(&Password.validate_filter_by/1) |> IO.inspect()
Password.load_report() |> Enum.count(&Password.validate_by_new_rule/1) |> IO.inspect()
