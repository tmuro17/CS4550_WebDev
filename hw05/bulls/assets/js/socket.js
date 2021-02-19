// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix";


//Socket code from the lecture and modified as needed

let socket = new Socket(
  "/socket",
  {params: {token: ""}}
);
socket.connect();

let channel = socket.channel("game:game", {});

let state = {
  guesses: [],
  error: ""
};

let callback = null;

const state_update = st => {
  state = st;

  if (callback) {
    callback(st);
  }
};

export const ch_join = cb => {
  callback = cb;
  callback(state);
};

export const ch_push = guess => {
  channel.push("guess", guess)
         .receive("ok", state_update)
         .receive("error", r => log_error("push", r));
};

export const ch_reset = () => {
  channel.push("reset", {})
         .receive("ok", state_update)
         .receive("error", r => log_error("push", r));
};

const log_error = (action, resp) => {
  console.log(`Unable to ${action}:`, resp);
};

channel.join()
       .receive("ok", state_update)
       .receive("error", r => log_error("join", r));

