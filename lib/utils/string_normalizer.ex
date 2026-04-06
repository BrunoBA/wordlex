defmodule Wordlex.Utils.StringNormalizer do
  @moduledoc """
  Utility functions for normalizing strings.
  """

  @doc """
  Removes diacritics (accents) from a string, returning only the base letters.

  Uses Unicode NFD normalization to decompose accented characters into their
  base letter and combining mark, then strips the combining marks.

  ## Examples

      iex> Wordlex.Utils.StringNormalizer.remove_accents("vocês")
      "voces"

      iex> Wordlex.Utils.StringNormalizer.remove_accents("ação")
      "acao"

      iex> Wordlex.Utils.StringNormalizer.remove_accents("château")
      "chateau"

  """
  @spec remove_accents(String.t()) :: String.t()
  def remove_accents(str) do
    str
    |> String.normalize(:nfd)
    |> String.replace(~r/\p{Mn}/u, "")
  end
end
