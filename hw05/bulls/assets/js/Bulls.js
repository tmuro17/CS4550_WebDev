import React, {useEffect, useState} from "react";
import 'milligram';

import {gameWon, guessesLeft} from "./game";
import {ch_join, ch_push, ch_reset} from "./socket";

const GameWon = ({reset}) => {
  return (
    <div className="container">
      <div className="row">
        <div className="column">
          <h2>You won!</h2>
        </div>
      </div>
      <div className="row">
        <div className="column">
          <button onClick={reset}>Reset</button>
        </div>
      </div>
    </div>
  );
};

const GameLost = ({reset}) => {
  return (
    <div className="container">
      <div className="row">
        <div className="column"><strong>You lost!</strong></div>
      </div>
      <div className="row">
        <div className="column">
          <button onClick={reset}>Reset</button>
        </div>
      </div>
    </div>
  );
};

//Idea of controls block taken from lecture
const Controls = ({guess, reset}) => {
  const [text, setText] = useState("");

  //Text control and keyPress logic taken from lecture
  const updateText = (ev) => {
    let text = ev.target.value;
    setText(text);
  };

  const keyPress = (ev) => {
    if (ev.key === "Enter") click();
  };

  const click = () => {
    guess(text);
    setText("");
  };

  return (
    <div className="row">
      <div className="column-25">
        <input type="text"
               value={text}
               onChange={updateText}
               onKeyPress={keyPress}/>
      </div>
      <div className="column">
        <button onClick={click}>Guess</button>
        <button onClick={reset}>Reset</button>
      </div>
    </div>
  );
};

const GuessInfo = ({guesses, remaining_guesses}) => {
  return (
    <div>
      <div className="row">
        <h2>Guesses Remaining: {remaining_guesses}</h2>
      </div>
      <div className="row">
        <h2>Guesses:</h2>
      </div>
      <div className="row">
        <ScoredGuesses scoredGuesses={guesses}/>
      </div>
    </div>
  );
};

//Taken from https://daveceddia.com/display-a-list-in-react/
// and then modified (drastically)
const ScoredGuesses = ({scoredGuesses}) => {
  return (
    <ol>
      {scoredGuesses.map((item) => (
        <Score result={item}/>
      ))}
    </ol>
  );
};

const Score = ({result}) => {
  const guess = result.guess;
  const bulls = result.bulls;
  const cows = result.cows;
  return (
    <li>
      {guess}: {bulls} Bulls, {cows} Cows
    </li>
  );
};


const FlashedMessaged = ({message}) => (
  <div>
    <strong className="error">{message}</strong>
  </div>
);


const Bulls = () => {
  const [state, setState] = useState({
    guesses: []
  });

  useEffect(() => {
    ch_join(setState);
  });

  const guess = (text) => ch_push({text: text});
  const reset = () => ch_reset();

  const remaining_guesses = guessesLeft(state);
  const game_won = gameWon(state);

  let guess_details;

  if (state.error === "") {
    guess_details = <GuessInfo guesses={state.guesses} remaining_guesses={remaining_guesses}/>;
  } else {
    guess_details = (
      <span>
        <GuessInfo guesses={state.guesses} remaining_guesses={remaining_guesses}/>
        <FlashedMessaged message={state.error}/>
      </span>
    );
  }

  if (game_won) {
    return <GameWon reset={reset}/>;
  } else if (remaining_guesses === 0) {
    return <GameLost reset={reset}/>;
  } else {
    return (
      <div className="container">
        {guess_details}
        <Controls guess={guess} reset={reset}/>
      </div>
    );
  }
};

export default Bulls;
