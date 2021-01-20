# StoneChallenge

![build](https://github.com/Mdsp9070/stone_challenge/workflows/actions/badge.svg?branch=main)

Olá! Como estão vocês? Primeiramente gostaria de dizer que me diverti muito fazendo o desafio, pois,
apesar de ter começado recentemente em Elixir, consegui aprender bastante coisa! Até porque
vocês juntaram 2 coisas que amo: CLIs e matemática haha!

O Elixir nos da uma vasta gama de opções para produzir CLIs, como o escript,
releases ou usando o próprio `mix`, a ferramente de build da linguagem.

Decidi usar o `mix` e suas chamadas `tasks`. Nomeei a task principal de `init`, logo
qualquer comando deverá começar com: `mix init` e então as opções.

Enfim, vamos ao que interessa:

Existem 2 formas de testar a aplicaçao ->

- Dando um arquivo de entrada com os dados
- Inserindo os dados pelas opções de linha de comando

ps: Qualquer dúvida, a CLI disponibiliza uma opção `--help`!

## Arquivo de entrada

OPÇÃO: `-f` ou `--file`

Dado um caminho para um arquivo `.yaml`, o programa irá ler o conteúdo e executar
a função `main` do módulo `StoneChallenge`.

Este repositório possui um arquivo de exemplo que pode ser lido [aqui](https://github.com/Mdsp9070/stone_challenge/blob/master/example.yaml)

Exemplo:

```sh
$ ls
example.yaml

$ mix init -f .example.yaml
<result>
```

## Inserindo os dados manualmente

OPÇÕES: `-i` ou `--items` e `-e` ou `--emails`

Neste modo, deverá ser inserido a quantidade de items e a quantida de emails.

Em seguida, a aplicação pedirá a quantidade de cada item, e depois o valor (em `float`) de cada item.

Os emails serão gerados automaticamente!

Exemplo:

```sh
$ mix init -i 1 -e 5
qtd item1: <int>
price item1: <float>

<result>
```
