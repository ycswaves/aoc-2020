defmodule Passport do
  @input_file_path Path.expand('./input.txt', __DIR__)
  @required_fields ~W/ecl pid eyr hcl byr iyr hgt/
  @valid_ecl ~W/amb blu brn gry grn hzl oth/
  @pid_regex ~r/^[0-9]{9}$/
  @field_capture_regex ~r/(?<hgt>^[0-9]+)(?<unit>(cm|in))$/
  @hcl_regex ~r/^#[0-9a-f]{6}$/

  def load_passports() do
    File.read!(@input_file_path)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, ~r/\s/, trim: true))
    |> Enum.map(&convert_passport/1)
  end

  @doc ~S"""
  Part 2: apply validations to various fields

  ## Parameters
    - `passport` - list of passport represented by a map of field_name-value pair

  ## Examples
      iex> Passport.load_passports |> Enum.count(&Passport.is_valid?/1)
      109
  """
  def is_valid?(passport) do
    required_fields_present?(passport) and !has_invalid_field?(passport)
  end

  def has_invalid_field?(passport) do
    passport
    |> Map.to_list()
    |> Enum.reject(fn {field_name, _} -> field_name == "cid" end)
    |> Enum.map(fn {field_name, value} -> {String.to_atom("is_#{field_name}_valid?"), value} end)
    |> Enum.reject(fn {validation_fn, value} -> apply(__MODULE__, validation_fn, [value]) end)
    |> Enum.count() > 0
  end

  @doc ~S"""
  Part 1: checking all required fields are present

  ## Parameters
    - `passport` - list of passport represented by a map of field_name-value pair

  ## Examples
      iex> Passport.load_passports |> Enum.count(&Passport.required_fields_present?/1)
      182
  """
  def required_fields_present?(passport) do
    passport_fields =
      passport
      |> Map.keys()
      |> MapSet.new()

    diff = MapSet.difference(MapSet.new(@required_fields), passport_fields)

    diff_size = MapSet.size(diff)
    diff_size == 0 or (diff_size == 1 and MapSet.member?(diff, "cid"))
  end

  def is_byr_valid?(byr), do: is_within_range?(byr, 1920, 2002)
  def is_iyr_valid?(iyr), do: is_within_range?(iyr, 2010, 2020)
  def is_eyr_valid?(eyr), do: is_within_range?(eyr, 2020, 2030)

  defp is_within_range?(num_str, min, max) do
    x = String.to_integer(num_str)
    min <= x and x <= max
  end

  def is_hgt_valid?(hgt_str) do
    case Regex.named_captures(@field_capture_regex, hgt_str) do
      %{"hgt" => hgt, "unit" => unit} ->
        case unit do
          "cm" -> is_within_range?(hgt, 150, 193)
          "in" -> is_within_range?(hgt, 59, 76)
        end

      _ ->
        false
    end
  end

  def is_hcl_valid?(hcl_str) do
    String.match?(hcl_str, @hcl_regex)
  end

  def is_ecl_valid?(ecl_str) do
    @valid_ecl
    |> MapSet.new()
    |> MapSet.member?(ecl_str)
  end

  def is_pid_valid?(pid_str) do
    String.match?(pid_str, @pid_regex)
  end

  defp convert_passport(passport_entry) do
    passport_entry
    |> Enum.map(&create_passport_field/1)
    |> Map.new()
  end

  defp create_passport_field(passport_field) do
    [field_name, value] = String.split(passport_field, ":")
    {field_name, value}
  end
end
