defmodule Bulls.Game do

  def new do
    %{
      secret: random_four(),
      guesses: [],
      scores: []
    }
  end

  def react_state(state, error_message) do
    guesses = state[:guesses]
    scores = state[:scores]

    guesses = Enum.zip(guesses, scores)
              |> Enum.map(
                   fn {g, s} ->
                     %{
                       guess: g,
                       bulls: s[:bulls],
                       cows: s[:cows],
                     }
                   end
                 )

    %{
      guesses: guesses,
      error: error_message,
    }
  end

  def random_four() do
    Enum.take_random(0..9, 4)
    |> Enum.join("")
  end

  def score_guess(secret, guess) do
    secret_list = String.graphemes(secret)
    guess_list = String.graphemes(guess)

    positional = Enum.zip(secret_list, guess_list)
                 |> Enum.filter(fn {x, y} -> x == y end)
                 |> Enum.count

    elemental = Enum.filter(guess_list, fn x -> Enum.member?(secret_list, x) end)
                |> Enum.count

    %{
      bulls: positional,
      cows: elemental - positional
    }
  end

  def valid_guess?(guess) do
    digits = guess
             |> String.graphemes
             |> MapSet.new

    cond do
      String.length(guess) != 4 -> {:invalid, "Guesses must be 4 digits in length"}
      MapSet.size(digits) != 4 -> {:invalid, "All digits must be distinct"}
      true -> {:valid, ""}
    end
  end

end
