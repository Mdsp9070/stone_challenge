defmodule Mix.Tasks.Init do
  @moduledoc """
  Nesse modulo, inicio as seeds e o desafio!
  """

  use Mix.Task

  import StoneChallenge.Colors

  @impl Mix.Task
  def run(args) do
    args
    |> parse_args()
    |> case do
      {:ok, parsed} ->
        cond do
          parsed[:help] ->
            get_version()
            |> build_help()

            System.halt(1)

          is_nil(parsed[:items]) or is_nil(parsed[:emails]) ->
            default_error()

            System.halt(1)

          true ->
            Faker.start()

            items =
              parsed[:items]
              |> parse_items()

            emails =
              parsed[:emails]
              |> parse_emails()

            {:ok, items, emails}
        end

      {:error, :default_error} ->
        System.halt(1)
    end
    |> StoneChallenge.main()
  end

  defp parse_emails(emails_num) do
    for _ <- 1..emails_num, into: [] do
      domain = Faker.Internet.PtBr.free_email_service()

      Faker.Person.PtBr.first_name()
      |> String.downcase()
      |> String.replace(~r|\s|, "")
      |> (&(&1 <> "@" <> domain)).()
    end
  end

  defp parse_items(items_num) do
    items = for _ <- 1..items_num, into: [], do: Faker.Commerce.product_name()

    qtd_items =
      for i <- 1..items_num, into: [] do
        IO.gets("qtd for item#{i}: ")
        |> String.trim()
        |> String.to_integer()
      end

    price_items =
      for i <- 1..items_num, into: [] do
        IO.gets("price for item#{i}: ")
        |> String.trim()
        |> String.to_float()
      end

    Enum.zip([items, qtd_items, price_items])
  end

  defp parse_args(args) do
    opts = [
      strict: [items: :integer, emails: :integer, help: :boolean],
      aliases: [i: :items, e: :emails, h: :help]
    ]

    case OptionParser.parse(args, opts) do
      {parsed, _, invalid} when parsed != [] ->
        unless Enum.empty?(invalid), do: unknown_opts(invalid)

        {:ok, parsed}

      {[], _, invalid} ->
        invalid |> unknown_opts() |> default_error()
    end
  end

  defp unknown_opts(invalid) do
    invalid =
      invalid
      |> Enum.map(fn {op, _} -> op end)

    desc = "I really don't know what to do with these options:\n#{inspect(invalid)}"

    "What are these?"
    |> warning(desc)
  end

  defp default_error(_ \\ false) do
    desc = "Please provide the items and emails number to generate!"

    "No items/emails number"
    |> error(desc)

    {:error, :default_error}
  end

  defp get_version do
    {:ok, vsn} = :application.get_key(:stone_challenge, :vsn)

    "#{green("stone_challenge")} v#{vsn}\n"
    |> IO.puts()

    {:ok, vsn}
  end

  defp build_help(_) do
    yellow("USAGE:") |> IO.puts()

    IO.puts("    mix init [options]\n")

    yellow("OPTIONS") |> IO.puts()
    green("    -h, --help") |> IO.puts()
    IO.puts("            Shows this help section")

    green("    -i, --items") |> IO.puts()
    IO.puts("            Generate a given number of items to use")

    green("    -e, --emails") |> IO.puts()
    IO.puts("            Generates a given number of emails to use")
  end
end
