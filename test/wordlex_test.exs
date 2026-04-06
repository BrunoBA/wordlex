defmodule WordlexTest do
  use ExUnit.Case

  describe "get_word/2" do
    test "returns empty string when list is empty" do
      assert Wordlex.get_word([], nil) == ""
    end

    test "returns a word from the list when callback is nil" do
      words = ["apple", "grape", "lemon"]
      word = Wordlex.get_word(words, nil)
      assert word in words
    end

    test "returns the single word when list has one element" do
      assert Wordlex.get_word(["apple"], nil) == "apple"
    end

    test "returns the word at the index provided by the callback" do
      words = ["apple", "grape", "lemon"]
      assert Wordlex.get_word(words, fn _ -> 1 end) == "grape"
    end

    test "falls back to random word when callback returns out of bounds index" do
      words = ["apple", "grape", "lemon"]
      word = Wordlex.get_word(words, fn _ -> 99 end)
      assert word in words
    end
  end

  describe "get_feedback/2" do
    test "returns all :ok when guess matches the word" do
      assert Wordlex.get_feedback("apple", "apple") == [:ok, :ok, :ok, :ok, :ok]
    end

    test "returns all :miss when no letters match" do
      assert Wordlex.get_feedback("apple", "story") == [:miss, :miss, :miss, :miss, :miss]
    end

    test "returns :exists for letters in wrong position" do
      assert Wordlex.get_feedback("apple", "acert") == [:ok, :miss, :exists, :miss, :miss]
    end

    test "returns the same quantity of elements as the quantity of characters from word" do
      assert Wordlex.get_feedback("apple", "applezzzz") == [:ok, :ok, :ok, :ok, :ok]
    end

    test "is case-insensitive" do
      assert Wordlex.get_feedback("Apple", "apple") == [:ok, :ok, :ok, :ok, :ok]
    end

    test "is accent-insensitive" do
      assert Wordlex.get_feedback("vocês", "voces") == [:ok, :ok, :ok, :ok, :ok]
    end

    test "check special characters are the same" do
      special_characters = "±!\"#$%&/()=?*\""

      assert Wordlex.get_feedback(special_characters, special_characters) == [
               :ok,
               :ok,
               :ok,
               :ok,
               :ok,
               :ok,
               :ok,
               :ok,
               :ok,
               :ok,
               :ok,
               :ok,
               :ok,
               :ok
             ]
    end

    test "check special characters contains :ok" do
      special_characters = "±!\"#$%&/()=?*\""

      assert Wordlex.get_feedback(special_characters, "±") == [
               :ok,
               :exists,
               :exists,
               :exists,
               :exists,
               :exists,
               :exists,
               :exists,
               :exists,
               :exists,
               :exists,
               :exists,
               :exists,
               :exists
             ]
    end
  end
end
