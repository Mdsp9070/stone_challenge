defmodule StoneChallengeTest do
  use ExUnit.Case, async: true

  describe "main/1" do
    defp emails_fixture(emails_num) do
      for _ <- 1..emails_num, into: [] do
        domain = Faker.Internet.PtBr.free_email_service()

        Faker.Person.PtBr.first_name()
        |> String.downcase()
        |> String.replace(~r|\s|, "")
        |> (&(&1 <> "@" <> domain)).()
      end
    end

    defp total_price(items) do
      items
      |> Enum.reduce(0, fn {qtd, price}, acc -> acc + qtd * price end)
    end

    defp sum_map(map) do
      map
      |> Enum.reduce(0, fn x, acc -> acc + x end)
    end

    test "basic test" do
      items = [
        {1, 1.0}
      ]

      emails = emails_fixture(3)

      {:ok, billing} = StoneChallenge.main({:ok, items, emails})

      billing = billing |> Map.to_list()

      assert total_price(items) == 100
      assert length(billing) == 3
      assert Enum.find(billing, fn {_e, v} -> v == 0.34 end)
      assert sum_map(billing) == 1.0
    end

    test "you can't hold me" do
      items = [
        {2, 2.0},
        {3, 1.5},
        {1, 1.0},
        {9, 4.3}
      ]

      emails = emails_fixture(2)

      {:ok, billing} = StoneChallenge.main({:ok, items, emails})

      assert total_price(items) == 48_200
      assert length(billing) == 2
      assert sum_map(billing) == 48.2
    end
  end
end
