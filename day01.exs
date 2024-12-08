defmodule Day1 do
  def parse do
    contents =
      File.read!("day01.txt")
      |> String.split(~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)

    list1 = Enum.drop_every(contents, 2) |> Enum.sort()
    list2 = Enum.take_every(contents, 2) |> Enum.sort()
    {list1, list2}
  end

  def part1 do
    {list1, list2} = parse()
    Enum.zip(list1, list2) |> Enum.reduce(0, fn {x, y}, acc -> acc + abs(y - x) end)
  end

  def part2 do
    {list1, list2} = parse()
    map = Enum.frequencies(list2)
    Enum.reduce(list1, 0, fn x, acc -> acc + x * Map.get(map, x, 0) end)
  end
end

IO.puts(Day1.part1())
IO.puts(Day1.part2())
