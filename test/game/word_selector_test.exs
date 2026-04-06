defmodule Wordlex.Game.WordSelectorTest do
  use ExUnit.Case

  alias Wordlex.Game.WordSelector

  describe "from_words/1" do
    test "returns {:error, :empty_list} when list is empty" do
      assert WordSelector.from_words([]) == {:error, :empty_list}
    end

    test "returns {:ok, word} when list has one word" do
      assert WordSelector.from_words(["apple"]) == {:ok, "apple"}
    end

    test "returns {:ok, word} with a word from the list" do
      words = ["apple", "grape", "lemon"]
      assert {:ok, word} = WordSelector.from_words(words)
      assert word in words
    end
  end

  describe "from_words/2" do
    test "returns the word at the index provided by the callback" do
      words = ["apple", "grape", "lemon"]
      assert WordSelector.from_words(words, fn _ -> 0 end) == {:ok, "apple"}
      assert WordSelector.from_words(words, fn _ -> 2 end) == {:ok, "lemon"}
    end

    test "falls back to random selection when index is out of bounds" do
      words = ["apple", "grape", "lemon"]
      assert {:ok, word} = WordSelector.from_words(words, fn _ -> 99 end)
      assert word in words
    end

    test "returns {:error, :empty_list} when list is empty" do
      assert WordSelector.from_words([], fn _ -> 0 end) == {:error, :empty_list}
    end

    test "callback receives the word list as argument" do
      words = ["apple", "grape", "lemon"]
      WordSelector.from_words(words, fn received_words ->
        assert received_words == words
        0
      end)
    end
  end
end
