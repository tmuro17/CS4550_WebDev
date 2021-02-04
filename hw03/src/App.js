import './App.css';
import {useState} from "react";
import {gameWon, guessesLeft, randomFour, scoreGuess} from "./game";
import 'milligram';

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

const GameLost = ({secret, reset}) => {
  return (
    <div className="container">
      <div className="row">
        <div className="column"><strong>You lost!</strong></div>
      </div>
      <div className="row">
        <div className="column">The secret was {secret}.</div>
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
  if (result === "REPEAT") {
    return (
      <li>No repeat digits</li>
    );
  } else if (result === "NOT_FOUR") {
    return (
      <li>Must be 4 digits</li>
    );
  } else {
    const guess = result.guess;
    const bulls = result.bulls;
    const cows = result.cows;
    return (
      <li>
        {guess}: {bulls} Bulls, {cows} Cows
      </li>
    );
  }
};


const App = () => {
  const [secret, setSecret] = useState(randomFour());
  const [scoredGuesses, setScoredGuesses] = useState([]);

  const guess = (text) => {
    const scored = scoreGuess(text, secret);
    setScoredGuesses(scoredGuesses.concat(scored));
  };

  const reset = () => {
    setSecret(randomFour());
    setScoredGuesses([]);
  };

  const remaining_guesses = guessesLeft(scoredGuesses);
  const game_won = gameWon(scoredGuesses, secret);

  if (game_won) {
    return <GameWon reset={reset}/>;
  } else if (remaining_guesses === 0) {
    return <GameLost secret={secret} reset={reset}/>;
  } else {
    return (
      <div className="container">
        <GuessInfo guesses={scoredGuesses} remaining_guesses={remaining_guesses}/>
        <Controls guess={guess} reset={reset}/>
      </div>
    );
  }
};

export default App;
