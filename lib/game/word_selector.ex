defmodule Wordlex.Game.WordSelector do
  @moduledoc """
  Selects a word from a list of words.

  Provides different strategies for word selection: random selection
  or index-based selection via a callback function.
  """

  @doc """
  Returns `{:error, :empty_list}` when the list is empty,
  or `{:ok, word}` with a randomly selected word.

  ## Examples

      iex> Worldex.Game.WorldSelector.from_words([])
      {:error, :empty_list}

      iex> Worldex.Game.WorldSelector.from_words(["apple", "grape"])
      {:ok, "apple"} # or {:ok, "grape"}, randomly

  """
  @spec from_words([String.t()]) :: {:ok, String.t()} | {:error, :empty_list}
  def from_words(words) when words == [] do
    {:error, :empty_list}
  end

  def from_words(words) do
    {:ok, Enum.random(words)}
  end

  @doc """
  Selects a word from the list using an index provided by `index_callback`.

  If the index is out of bounds, falls back to random selection.
  Returns `{:ok, word}` on success or `{:error, :empty_list}` if the list is empty.

  ## Examples

      iex> Worldex.Game.WorldSelector.from_words(["apple", "grape"], fn words -> rem(Date.utc_today().day, length(words)) end)
      {:ok, "apple"}

  """
  @spec from_words([String.t()], ([String.t()] -> non_neg_integer())) ::
          {:ok, String.t()} | {:error, :empty_list}
  def from_words(words, index_callback) do
    index = index_callback.(words)

    case Enum.at(words, index) do
      nil -> from_words(words)
      word -> {:ok, word}
    end
  end
end
