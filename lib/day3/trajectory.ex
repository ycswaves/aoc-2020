defmodule Trajectory do
  @input_file_path Path.expand('./input.txt', __DIR__)

  @doc ~S"""
  Part 2: multiplication of the counts the trees encounted for multiple moves, 
  e.g. 
  - Right 1, down 1.
  - Right 3, down 1. 
  - Right 5, down 1.
  - Right 7, down 1.
  - Right 1, down 2.

  ## Parameters
    - `grid` - 2D list storing the map
    - `moves` - list of 2-element tuple represents the move

  ## Examples
      iex> all_moves = [{3,1},{1,1},{5,1},{7,1},{1,2}]
      iex> Trajectory.load_map |> Trajectory.traverse_all(all_moves)
      9533698720
  """
  def traverse_all(grid, moves) do
    Enum.reduce(moves, 1, &(traverse(grid, &1) * &2))
  end

  @doc ~S"""
  Part 1: count the trees encounted for a single move, e.g. "Right 1, down 1"

  ## Parameters
    - `grid` - 2D list storing the map
    - `move` - 2 element tuple represents the move

  ## Examples
      iex> Trajectory.load_map |> Trajectory.traverse({3,1})
      230
  """
  def traverse(grid, {lateral_step, vertical_step}) do
    row_size =
      grid
      |> Enum.at(0)
      |> Enum.count()

    grid
    |> Enum.take_every(vertical_step)
    |> count_tree({lateral_step, row_size, 0}, 0)
  end

  defp count_tree([], _, tree_count), do: tree_count

  defp count_tree([row | rest], {lateral_step, row_size, row_count}, tree_count) do
    row_pos = Integer.mod(lateral_step * row_count, row_size)
    row_count = row_count + 1

    tree_count =
      case Enum.at(row, row_pos) do
        "#" -> tree_count + 1
        _ -> tree_count
      end

    count_tree(rest, {lateral_step, row_size, row_count}, tree_count)
  end

  def load_map() do
    File.read!(@input_file_path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
