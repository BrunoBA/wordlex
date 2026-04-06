defmodule Wordlex.Game.FeedbackTest do
  use ExUnit.Case

  alias Wordlex.Game.Feedback

  describe "check/2" do
    test "all letters in the correct position" do
      assert Feedback.check("apple", "apple") == [:ok, :ok, :ok, :ok, :ok]
    end

    test "no letters in common" do
      assert Feedback.check("apple", "story") == [:miss, :miss, :miss, :miss, :miss]
    end

    test "all letters exist but in wrong positions" do
      assert Feedback.check("abcde", "bcdea") == [:exists, :exists, :exists, :exists, :exists]
    end

    test "mix of :ok, :exists and :miss" do
      assert Feedback.check("apple", "acert") == [:ok, :miss, :exists, :miss, :miss]
    end

    test "letter exists but is already matched in correct position" do
      # 'a' appears once in "apple", guess has 'a' in wrong spot and another 'a' in correct spot
      assert Feedback.check("apple", "aappl") == [:ok, :miss, :ok, :exists, :exists]
    end

    test "case insensitive comparison" do
      assert Feedback.check("Apple", "apple") == [:ok, :ok, :ok, :ok, :ok]
    end

    # Accented characters
    test "accented letter in word matches unaccented in guess" do
      # "vocês" vs "voces" — ê treated as e
      assert Feedback.check("vocês", "voces") == [:ok, :ok, :ok, :ok, :ok]
    end

    test "unaccented letter in word matches accented in guess" do
      # "voces" vs "vocês" — e treated as ê
      assert Feedback.check("voces", "vocês") == [:ok, :ok, :ok, :ok, :ok]
    end

    test "accented letter counts as :exists when in wrong position" do
      # "êxito" vs "texto" — ê/e exists in word but wrong position
      assert Feedback.check("êxito", "texto") == [:miss, :exists, :exists, :ok, :ok]
    end

    test "Guesses with less characters should be a :miss" do
      # For cases where there's less characters for guesses the nil will be counted as :miss
      assert Feedback.check("abc", "a") == [:ok, :miss, :miss]
    end

    test "Empty guesses should return a string of :miss" do
      assert Feedback.check("abc", "") == [:miss, :miss, :miss]
    end
  end
end
