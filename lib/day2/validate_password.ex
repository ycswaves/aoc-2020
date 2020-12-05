defmodule Password do
  @moduledoc """
  AOC day 2 tasks
  """

  @input_file_path Path.expand('./input.txt', __DIR__)

  @doc ~S"""
  Part 1: validate password using **old** policy, by removing required letter and compare the length with the original password

  ## Parameters
    - `entry` - String that represents a rule-password entry from the input file

  ## Examples
      iex> Password.load_report() |> Enum.count(&Password.validate_filter_by/1)
      580
  """
  def validate_filter_by(entry) do
    [range, required_letter, password] = tokenize_rule(entry)

    password_without_required = String.replace(password, required_letter, "")
    required_letter_count = String.length(password) - String.length(password_without_required)

    [min, max] = parse_range(range)
    min <= required_letter_count and required_letter_count <= max
  end

  @doc ~S"""
  Part 1: validate password using **old** policy, using `Enum.frequencies`

  ## Parameters
    - `entry` - String that represents a rule-password entry from the input file

  ## Examples
      iex> Password.load_report() |> Enum.count(&Password.validate_group_by/1)
      580
  """
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

  @doc ~S"""
  Part 1: validate password using **old** policy, using regex

  ## Parameters
    - `entry` - String that represents a rule-password entry from the input file

  ## Examples
      iex> Password.load_report() |> Enum.count(&Password.validate_by_regex/1)
      580
  """
  def validate_by_regex(entry) do
    [range, required_letter, password] = tokenize_rule(entry)

    range = String.replace(range, "-", ",")

    validation_regex =
      Regex.compile!("^[^#{required_letter}]*#{required_letter}{#{range}}[^#{required_letter}]*$")

    sorted_password =
      password
      |> String.graphemes()
      |> Enum.sort()
      |> Enum.join()

    String.match?(sorted_password, validation_regex)
  end

  @doc ~S"""
  Part 2: validate password using **new** policy

  ## Parameters
    - `entry` - String that represents a rule-password entry from the input file

  ## Example
      iex> Password.load_report() |> Enum.count(&Password.validate_by_new_rule/1)
      611
  """
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
    |> String.split("\n", trim: true)
  end
end
