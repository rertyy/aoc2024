defmodule Day4 do
  defp read_file() do
    File.read!("day04.txt")
  end

  defp parse(input) do
    rows = String.split(input, "\n", trim: true)

    nrows = length(rows)

    ncols = hd(rows) |> String.codepoints() |> length()

    grid =
      rows
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, i} ->
        line
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.map(fn {x, j} ->
          {{i, j}, x}
        end)
      end)
      |> Map.new()

    {grid, nrows, ncols}
  end

  def part1 do
    input = read_file()
    {grid, nrows, ncols} = parse(input)

    xmas = ["X", "M", "A", "S"]

    directions =
      Enum.to_list(-1..1)
      |> Enum.flat_map(fn i ->
        Enum.to_list(-1..1)
        |> Enum.map(fn j -> {i, j} end)
        |> Enum.reject(fn {i, j} -> i == 0 and j == 0 end)
      end)

    grid
    |> Enum.flat_map(fn {{i, j}, _v} ->
      Enum.map(directions, fn {di, dj} -> recurse(grid, i, j, xmas, di, dj, nrows, ncols) end)
    end)
    |> Enum.sum()
  end

  defp recurse(_grid, _i, _j, [], _di, _dj, _nrows, _ncols), do: 1

  defp recurse(grid, i, j, [hd | tl], di, dj, nrows, ncols) do
    if i < 0 or i >= nrows or j < 0 or j >= ncols do
      0
    else
      value = Map.fetch!(grid, {i, j})

      if value == hd do
        recurse(grid, i + di, j + dj, tl, di, dj, nrows, ncols)
      else
        0
      end
    end
  end

  defp count_crosses(grid, i, j, nrows, ncols) do
    cond do
      i <= 0 or i >= nrows - 1 or (j <= 0 or j >= ncols - 1) -> 0
      # Check "A" in centre
      Map.fetch!(grid, {i, j}) == "A" -> check_diags(grid, i, j)
      true -> 0
    end
  end

  defp check_diags(grid, i, j) do
    top_left = Map.fetch!(grid, {i - 1, j - 1})
    top_right = Map.fetch!(grid, {i - 1, j + 1})
    bottom_left = Map.fetch!(grid, {i + 1, j - 1})
    bottom_right = Map.fetch!(grid, {i + 1, j + 1})

    diag1 = (top_left == "M" and bottom_right == "S") or (top_left == "S" and bottom_right == "M")
    diag2 = (top_right == "M" and bottom_left == "S") or (top_right == "S" and bottom_left == "M")

    if diag1 and diag2 do
      1
    else
      0
    end
  end

  def part2 do
    input = read_file()
    {grid, nrows, ncols} = parse(input)

    grid
    |> Enum.map(fn {{i, j}, _v} -> count_crosses(grid, i, j, nrows, ncols) end)
    |> Enum.sum()
  end
end

IO.puts(Day4.part1())
IO.puts(Day4.part2())
