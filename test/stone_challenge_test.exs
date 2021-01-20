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
      |> Enum.reduce(0, fn {_e, x}, acc -> acc + x end)
    end

    test "basic test" do
      items = [
        {1, 100}
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
        {2, 200},
        {3, 150},
        {1, 100},
        {9, 430}
      ]

      emails = emails_fixture(2)

      {:ok, billing} = StoneChallenge.main({:ok, items, emails})

      assert total_price(items) == 4_820
      assert map_size(billing) == 2
      assert sum_map(billing) == 48.2
    end

    test "ok, that's will scary you" do
      qtds = for x <- 1..15, into: [], do: x
      prices = for _ <- 1..15, into: [], do: round(Enum.random(1..1_000) / 12 * 100)

      items = Enum.zip(qtds, prices)

      emails = emails_fixture(5)

      {:ok, billing} = StoneChallenge.main({:ok, items, emails})

      assert map_size(billing) == 5
      assert total_price(items) == sum_map(billing) |> Kernel.*(100) |> round()
    end
  end

  test "let's try to read from file!" do
    path = Path.expand("./example.yaml")

    {:ok, %{"entries" => %{"emails" => emails, "items" => to_parse_items}}} =
      YamlElixir.read_from_file(path)

    items =
      to_parse_items
      |> Map.to_list()
      |> Enum.map(fn {qtd, v} -> {qtd, round(v * 100)} end)

    {:ok, billing} = StoneChallenge.main({:ok, items, emails})

    assert map_size(billing) == length(emails)
    assert total_price(items) == sum_map(billing) |> Kernel.*(100) |> round()
  end
end
