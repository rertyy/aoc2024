defmodule Day2 do
  defp parse do
    File.read!("day02.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp check_report_helper?([], _, _), do: true

  defp check_report_helper?([a | tail], prev, :desc) do
    prev - a > 0 and prev - a <= 3 and check_report_helper?(tail, a, :desc)
  end

  defp check_report_helper?([a | tail], prev, :asc) do
    a - prev > 0 and a - prev <= 3 and check_report_helper?(tail, a, :asc)
  end

  defp check_report?([]), do: true
  defp check_report?([_]), do: true

  defp check_report?([a, b | tail]) do
    if a < b do
      check_report_helper?([b | tail], a, :asc)
    else
      check_report_helper?([b | tail], a, :desc)
    end
  end

  def part1 do
    parse()
    |> Enum.filter(&check_report?/1)
    |> Enum.count()
  end

  def part2 do
    parse()
    |> Enum.filter(fn report ->
      Enum.with_index(report)
      |> Enum.any?(fn {_, i} ->
        check_report?(List.delete_at(report, i))
      end)
    end)
    |> Enum.count()
  end
end

IO.puts(Day2.part1())
IO.puts(Day2.part2())
