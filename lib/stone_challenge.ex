defmodule StoneChallenge do
  @moduledoc """
  Aqui e onde a magica acontece
  """

  import StoneChallenge.Colors, only: [success: 1]

  def main({:ok, items, emails}) do
    total_price_items =
      items
      |> Enum.reduce(0, fn {qtd, price}, acc -> acc + qtd * price end)

    total_price_items
    |> build_bill()

    total_price_items
    |> distribute(length(emails))
    |> Enum.map(&divide_hundred/1)
    |> Enum.zip(emails)
    |> Map.new(fn {v, e} -> {e, v} end)
    |> build_result()
  end

  defp distribute(numerator, divisor) do
    {quot, remain} = quot_rem(numerator, divisor)

    quot
    |> do_distribute(remain, divisor, [])
  end

  defp quot_rem(numerator, divisor) do
    {div(numerator, divisor), rem(numerator, divisor)}
  end

  defp do_distribute(_value, _rem, 0, acc), do: acc |> Enum.reverse()

  defp do_distribute(value, 0, count, acc) do
    acc = [next_amount(value, 0, count) | acc]
    count = decrement(count)

    value
    |> do_distribute(0, count, acc)
  end

  defp do_distribute(value, remain, count, acc) do
    acc = [next_amount(value, remain, count) | acc]
    remain = decrement(remain)
    count = decrement(count)

    value
    |> do_distribute(remain, count, acc)
  end

  defp next_amount(0, -1, count) when count > 0, do: -1
  defp next_amount(value, 0, _count), do: value
  defp next_amount(value, _rem, _count), do: increment(value)

  defp increment(n) when n >= 0, do: n + 1
  defp increment(n) when n < 0, do: n - 1

  defp decrement(n) when n >= 0, do: n - 1
  defp decrement(n) when n < 0, do: n + 1

  defp build_bill(total) do
    "You all bought so many things! Here's the total: #{divide_hundred(total)}"
    |> success()
  end

  defp build_result(map) do
    "Here's the billing:"
    |> success()

    map
    |> inspect()
    |> IO.puts()

    {:ok, map}
  end

  defp divide_hundred(x), do: x / 100
end
