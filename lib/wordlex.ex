defmodule Wordlex do
  @moduledoc """
  Documentation for `Wordlex`.
  """
  alias Wordlex.Game.Feedback
  alias Wordlex.Game.WordSelector

  @doc """
  Returns a word from the given list.

  If `callback` is `nil`, a random word is selected. Otherwise, the callback
  receives the list and must return an index to select from.

  ## Examples

      iex> Wordlex.get_word(["apple"], nil)
      "banana"

      iex> Wordlex.get_word(["apple"], fn words -> rem(Date.utc_today().day, length(words)) end)
      "apple"

  """
  def get_word([], _), do: ""

  def get_word(words, nil) do
    {:ok, word} = WordSelector.from_words(words)

    word
  end

  def get_word(words, callback) do
    {:ok, word} = WordSelector.from_words(words, callback)

    word
  end

  @doc """
  Compares a guess against the target word and returns letter-by-letter feedback.

  Each element in the returned list is one of:
  - `:ok` — correct letter in the correct position
  - `:exists` — letter exists in the word but in the wrong position
  - `:miss` — letter does not exist in the word

  ## Examples

      iex> Wordlex.get_feedback("banana", "banane")
      [:ok, :ok, :ok, :ok, :ok, :miss]

  """
  def get_feedback(word, guess), do: Feedback.check(word, guess)
end
