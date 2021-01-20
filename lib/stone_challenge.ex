defmodule StoneChallenge do
  @moduledoc """
  Aqui e onde a magica acontece
  """

  import StoneChallenge.Colors, only: [success: 1]

  def main({:ok, items, emails}) do
    total_price_items =
      items
      |> Enum.reduce(0, fn {_name, qtd, price}, acc -> acc + qtd * price end)

    total_price_items
    |> build_bill()

    total_price_items
    |> distribute(length(emails))
    |> Enum.zip(emails)
    |> Map.new(fn {v, e} -> {e, v} end)
    |> build_result()
  end

  defp distribute(numerator, divisor, precision \\ 2) do
    precision = :math.pow(10, precision) |> round()

    {quot, remain} = quot_rem(numerator * precision, divisor)

    xs = for _ <- 1..remain, into: [], do: (quot + 1) / precision

    xs ++ for(_ <- 1..(divisor - remain), into: [], do: quot / precision)
  end

  defp quot_rem(numerator, divisor) do
    {floor(numerator / divisor), numerator |> floor() |> rem(divisor)}
  end

  defp build_bill(total) do
    "You all bought so many things! Here's the total: #{total}"
    |> success()
  end

  defp build_result(map) do
    "Here's the billing:"
    |> success()

    map
    |> inspect()
    |> IO.puts()
  end
end
