# Wordlex

Core game logic for a Wordle-inspired word guessing game, written in Elixir.

Wordlex provides the building blocks to run a daily word game:

- **Word selection** — picks the word of the day from a list, either randomly or by a deterministic index (e.g. based on the current date)
- **Guess feedback** — compares a player's guess against the target word and returns letter-by-letter feedback: `:ok` (correct position), `:exists` (wrong position), or `:miss` (not in word)
- **String normalization** — accent-insensitive and case-insensitive comparisons, so `ê` matches `e` and `A` matches `a`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `wordlex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:wordlex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/wordlex>.

