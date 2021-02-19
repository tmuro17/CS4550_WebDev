export const guessesLeft = state => 8 - state.guesses.length;

export const gameWon = state =>
  state
    .guesses
    .filter(x => x.bulls === 4)
    .length > 0;
