defmodule Wordlex.Game.Feedback do
  alias Wordlex.Utils.StringNormalizer

  @moduledoc """
  Compares a guess against the word of the day and returns letter-by-letter feedback.

  Each position in the returned list is one of:
  - `:ok` — correct letter in the correct position
  - `:exists` — letter exists in the word but in the wrong position
  - `:miss` — letter does not exist in the word

  Comparison is case-insensitive and accent-insensitive (e.g. `ê` is treated as `e`).

  ## Examples

      iex> Wordlex.Game.Feedback.check("apple", "apple")
      [:ok, :ok, :ok, :ok, :ok]

      iex> Wordlex.Game.Feedback.check("apple", "story")
      [:miss, :miss, :miss, :miss, :miss]

      iex> Wordlex.Game.Feedback.check("apple", "acert")
      [:ok, :miss, :exists, :miss, :miss]

      iex> Wordlex.Game.Feedback.check("vocês", "voces")
      [:ok, :ok, :ok, :ok, :ok]

  """

  @type feedback :: :ok | :exists | :miss

  @spec check(String.t(), String.t()) :: [feedback()]
  def check(word, guess) when word == guess do
    string_length = String.length(word)
    List.duplicate(:ok, string_length)
  end

  def check(word, guess) do
    list_word =
      word |> StringNormalizer.remove_accents() |> String.downcase() |> String.codepoints()

    list_guess =
      guess |> StringNormalizer.remove_accents() |> String.downcase() |> String.codepoints()

    {new_word, new_guess} = map_correct_positions(list_word, list_guess)

    handle(0, new_word, new_guess)
  end

  @spec map_correct_positions([String.t()], [String.t()]) ::
          {[String.t() | nil], [String.t() | :ok]}
  def map_correct_positions(word, guess) do
    word_with_index = Enum.with_index(word)

    new_guess =
      Enum.map(word_with_index, fn {letter, index} ->
        guessed_word = Enum.at(guess, index, :miss)

        case guessed_word == letter do
          true -> :ok
          false -> guessed_word
        end
      end)

    new_word =
      Enum.map(word_with_index, fn {letter, index} ->
        guessed_word = Enum.at(guess, index)

        case guessed_word == letter do
          true -> nil
          false -> letter
        end
      end)

    {new_word, new_guess}
  end

  @spec map_miss_positions([String.t() | feedback()]) :: [feedback()]
  def map_miss_positions(word) do
    Enum.map(word, fn x ->
      cond do
        is_nil(x) === true -> :miss
        is_atom(x) === true -> x
        true -> :miss
      end
    end)
  end

  defp map_exist_positions(index, word, guess) do
    letter_guess = Enum.at(guess, index)
    word_index = Enum.find_index(word, fn x -> x == letter_guess end)

    cond do
      word_index != nil ->
        new_word = List.replace_at(word, word_index, nil)
        new_guess = List.replace_at(guess, index, :exists)

        {new_word, new_guess}

      true ->
        {word, guess}
    end
  end

  @spec handle(non_neg_integer(), [String.t() | nil], [String.t() | feedback()]) :: [feedback()]
  def handle(index, word, guess) do
    if index === length(word) do
      map_miss_positions(guess)
    else
      {word, guess} = map_exist_positions(index, word, guess)
      handle(index + 1, word, guess)
    end
  end
end
