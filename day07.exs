defmodule Day7 do
  defp read_file() do
    File.read!("data/day07.txt")
    # File.read!("temp.txt")
  end

  defp parse(input) do
    rows =
      String.split(input, "\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, ":")
        |> Enum.flat_map(&String.split/1)
        |> Enum.map(&String.to_integer/1)
      end)

    rows
  end

  # or generate combinations of len-1 operators then Enum.any on reduce(first, op.(acc,next))
  def is_valid?(line) do
    [expected | rem] = line

    check_options(expected, 0, &+/2, rem) or
      check_options(expected, 1, &*/2, rem)
  end

  def check_options(expected, val, _op, []), do: expected == val

  def check_options(expected, val, op, rem) do
    if val > expected do
      false
    else
      [hd | tl] = rem

      check_options(expected, op.(val, hd), &+/2, tl) or
        check_options(expected, op.(val, hd), &*/2, tl)
    end
  end

  def part1 do
    input = read_file()

    parse(input)
    |> Enum.filter(&is_valid?/1)
    |> Enum.map(&hd/1)
    |> Enum.sum()
  end

  defp concat(a, b) do
    String.to_integer("#{a}#{b}")
  end

  def part2 do
    input = read_file()

    # ops = [&+/2, &*/2, &concat/2]

    parse(input)
    # |> Enum.filter(&valid2?(&1, ops))
    |> Enum.filter(&is_valid3?/1)
    |> Enum.map(&hd/1)
    |> Enum.sum()
  end

  def is_valid3?(line) do
    [expected | rem] = line

    check_options3(expected, 0, &+/2, rem) or
      check_options3(expected, 1, &*/2, rem) or
      check_options3(expected, 0, &concat/2, rem)
  end

  def check_options3(expected, val, _op, []), do: expected == val

  def check_options3(expected, val, op, rem) do
    [hd | tl] = rem

    if val > expected do
      false
    else
      check_options3(expected, op.(val, hd), &+/2, tl) or
        check_options3(expected, op.(val, hd), &*/2, tl) or
        check_options3(expected, op.(val, hd), &concat/2, tl)
    end
  end
end

Day7.part1() |> IO.puts()
Day7.part2() |> IO.puts()

#### This is slow probably because of the repeated computation
#### (no memoization) of &possibilities/2 which also need a lot of lists
# defp valid2?(line, ops) do
#   [expected | rem] = line
#   len = length(rem)
#
#   combis =
#     possibilities(ops, len - 1)
#
#   Enum.any?(combis, fn combi ->
#     expected == evaluate(combi, rem, expected)
#   end)
# end
#
# defp possibilities(operators, count) do
#   List.duplicate(operators, count)
#   |> Enum.reduce([[]], fn ops, acc ->
#     Enum.flat_map(acc, fn combi ->
#       Enum.map(ops, fn op ->
#         [op | combi]
#       end)
#     end)
#   end)
# end
#
# defp evaluate(combi, vals, expected) do
#   [hd | rest] = vals
#   zipped = Enum.zip(combi, rest)
#
#   Enum.reduce_while(zipped, hd, fn {op, x}, acc ->
#     val = op.(acc, x)
#
#     if val > expected do
#       {:halt, val}
#     else
#       {:cont, val}
#     end
#   end)
# end
