defmodule Day3 do
  defp parse do
    File.read!("day03.txt")
  end

  def part1 do
    contents = parse()

    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, contents)
    |> Enum.reduce(0, fn [_, x, y], acc ->
      acc + String.to_integer(x) * String.to_integer(y)
    end)
  end

  defp get_index(re, s) do
    Regex.scan(re, s, return: :index)
    |> Enum.map(fn [first_match | _] -> elem(first_match, 0) end)
  end

  defp get_ranges([], [], ranges), do: Enum.reverse(ranges)
  defp get_ranges([], [_ | _], ranges), do: Enum.reverse(ranges)

  defp get_ranges([head | _], [], ranges) do
    ranges = [{head, :infinity} | ranges]
    Enum.reverse(ranges)
  end

  # dos, donts, allowed ranges
  defp get_ranges([a | b], [c | d], ranges) do
    cond do
      # it's fine if you have [{1,3}, {2,3}, etc]
      a < c -> get_ranges(b, [c | d], [{a, c - 1} | ranges])
      a > c -> get_ranges([a | b], d, ranges)
      a == c -> raise "dos == donts"
    end
  end

  defp get_contents([], [], [], sum), do: sum
  defp get_contents([], _, _, sum), do: sum
  defp get_contents(_, [], _, sum), do: sum
  defp get_contents(_, _, [], sum), do: sum

  @spec get_contents(list(integer()), list(integer()), list({integer(), integer()}), integer()) ::
          integer()
  defp get_contents(
         [mult | mult_rest],
         [mult_ind | ind_rest],
         [{r1, r2} | range_rest],
         sum
       ) do
    cond do
      # Mult_ind within current range
      mult_ind >= r1 and mult_ind < r2 ->
        get_contents(mult_rest, ind_rest, [{r1, r2} | range_rest], sum + mult)

      # Beyond curr range
      mult_ind > r2 ->
        get_contents([mult | mult_rest], [mult_ind | ind_rest], range_rest, sum)

      # Before curr range
      mult_ind < r1 ->
        get_contents(mult_rest, ind_rest, [{r1, r2} | range_rest], sum)
    end
  end

  ### On hindsight just split the text using don't() and do() recursively using a flag, then scan on the enabled parts
  def part2 do
    contents = parse()
    dos = get_index(~r/do\(\)/, contents)
    dos = [0 | dos]

    donts = get_index(~r/don't\(\)/, contents)
    ranges = get_ranges(dos, donts, [])

    mult_re = ~r/mul\((\d{1,3}),(\d{1,3})\)/
    mult_inds = get_index(mult_re, contents)

    mults =
      Regex.scan(mult_re, contents)
      |> Enum.map(fn [_, x, y] -> String.to_integer(x) * String.to_integer(y) end)

    get_contents(mults, mult_inds, ranges, 0)
  end
end

IO.puts(Day3.part1())
IO.puts(Day3.part2())
