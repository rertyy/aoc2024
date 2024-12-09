defmodule Day6 do
  @up {-1, 0}
  @right {0, 1}
  @down {1, 0}
  @left {0, -1}

  defp read_file() do
    File.read!("day06.txt")
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

  defp at_exit?({i, j}, dir, nrows, ncols) do
    case dir do
      @up -> i == 0
      @down -> i == nrows - 1
      @left -> j == 0
      @right -> j == ncols - 1
    end
  end

  defp move({i, j}, grid, nrows, ncols, visited, dir, func) do
    {di, dj} = dir

    next_loc = {i + di, j + dj}

    if Map.fetch!(grid, next_loc) != "#" do
      func.(next_loc, grid, nrows, ncols, visited, dir)
    else
      next_dir =
        case dir do
          @up -> @right
          @right -> @down
          @down -> @left
          @left -> @up
        end

      move({i, j}, grid, nrows, ncols, visited, next_dir, func)
    end
  end

  defp travel({i, j}, grid, nrows, ncols, visited, dir) do
    visited = MapSet.put(visited, {i, j})

    if at_exit?({i, j}, dir, nrows, ncols) do
      visited
    else
      move({i, j}, grid, nrows, ncols, visited, dir, &travel/6)
    end
  end

  def day6 do
    input = read_file()
    {grid, nrows, ncols} = parse(input)

    start =
      Enum.reduce_while(grid, {0, 0}, fn {{i, j}, x}, acc ->
        if x == "^" do
          {:halt, {i, j}}
        else
          {:cont, acc}
        end
      end)

    visited = MapSet.new()

    path = travel(start, grid, nrows, ncols, visited, @up)

    path
    |> MapSet.size()
    |> IO.inspect(label: "part1")

    path
    |> Enum.reject(fn coord -> coord == start end)
    |> Enum.filter(fn coord ->
      forms_loop?(coord, grid, nrows, ncols, start)
    end)
    |> Enum.count()
    |> IO.inspect(label: "part2")
  end

  defp forms_loop?(coord, grid, nrows, ncols, start) do
    grid = Map.put(grid, coord, "#")
    travel_with_loop?(start, grid, nrows, ncols, MapSet.new(), @up)
  end

  defp travel_with_loop?({i, j}, grid, nrows, ncols, visited, dir) do
    cond do
      MapSet.member?(visited, {{i, j}, dir}) ->
        true

      at_exit?({i, j}, dir, nrows, ncols) ->
        false

      true ->
        visited = MapSet.put(visited, {{i, j}, dir})
        move({i, j}, grid, nrows, ncols, visited, dir, &travel_with_loop?/6)
    end
  end
end

Day6.day6()

# Note: a new obstacle doesn't mean that the guard reaches this obstacle in the same dir as if without obstacle
