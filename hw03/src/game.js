import _ from "lodash";

export const scoreGuess = (guess, secret) => {
  if (guess.length !== 4) {
    return "NOT_FOUR";
  }

  const guess_arr = guess.split("");
  const secret_arr = secret.split("");
  const set = new Set(guess_arr);

  if (set.size !== 4) {
    return "REPEAT";
  }


  const numElement =
    guess_arr.filter((c) => secret.includes(c))
      .length;

  const numPositional =
    _.zip(guess_arr, secret_arr)
     .filter(([x, y]) => x === y)
      .length;

  return {
    guess: guess,
    bulls: numPositional,
    cows: numElement - numPositional
  };
};

export const guessesLeft = guesses => 8 - guesses.length;


export const randomFour = () => {
  const digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  return _.sampleSize(digits, 4).join("");
};

export const gameWon = (guesses, secret) =>
  guesses
    .filter((g) => typeof g === "object")
    .filter((g) => g.guess === secret)
    .length > 0;
