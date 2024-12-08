defmodule Day5 do
  defp read_file() do
    File.read!("day05.txt")
  end

  defp parse_part(part, delim) do
    part
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(delim, trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp parse(input) do
    [p1 | p2] = String.split(input, "\n\n", trim: true)
    p1 = parse_part(p1, "|")
    p2 = parse_part(hd(p2), ",")

    {p1, p2}
  end

  defp get_middle(update) do
    len = length(update)
    middle = Enum.at(update, div(len, 2))
    middle
  end

  # defp _generate_rules_map(rules) do
  #   # an adj list
  #   rules
  #   |> Enum.reduce(%{}, fn {x, y}, acc ->
  #     acc
  #     |> Map.update(x, MapSet.new([y]), fn existing -> MapSet.put(existing, y) end)
  #   end)
  # end

  defp generate_rules(rules) do
    rules
    |> Enum.reduce(MapSet.new(), fn [x, y], acc ->
      acc
      |> MapSet.put({x, y})
    end)
  end

  defp is_valid?(update, rules) do
    indexed = Enum.with_index(update)

    indexed
    |> Enum.all?(fn {x, i} ->
      !Enum.any?(indexed, fn {y, j} ->
        i < j and
          MapSet.member?(rules, {y, x})
      end)
    end)
  end

  def part1 do
    {p1, p2} = read_file() |> parse()

    rules = generate_rules(p1)

    p2
    |> Enum.filter(fn update -> is_valid?(update, rules) end)
    |> Enum.map(&get_middle/1)
    |> Enum.sum()
  end

  defp reorder(update, rules) do
    Enum.sort(update, fn x, y -> MapSet.member?(rules, {x, y}) end)
  end

  def part2 do
    {p1, p2} = read_file() |> parse()

    rules = generate_rules(p1)

    p2
    |> Enum.filter(fn update -> !is_valid?(update, rules) end)
    |> Enum.map(fn update -> reorder(update, rules) end)
    |> Enum.map(&get_middle/1)
    |> Enum.sum()
  end
end

IO.puts(Day5.part1())
IO.puts(Day5.part2())
