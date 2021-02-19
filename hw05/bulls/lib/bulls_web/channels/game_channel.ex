defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  alias Bulls.Game

  @impl true
  def join("game:" <> _, payload, socket) do
    if authorized?(payload) do
      game = Game.new
      socket = socket
               |> assign(:game, game)
      react_state = Game.react_state(game, "")
      {:ok, react_state, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("guess", %{"text" => txt}, socket) do
    game = socket.assigns[:game]
    {isValid, reason} = Game.valid_guess?(txt)

    if isValid == :valid do
      secret = game[:secret]
      guesses = game[:guesses] ++ [txt]
      score = Game.score_guess(secret, txt)
      scores = game[:scores] ++ [score]

      game = %{
        secret: secret,
        guesses: guesses,
        scores: scores,
      }

      socket = assign(socket, :game, game)
      react_state = Game.react_state(game, "")

      {:reply, {:ok, react_state}, socket}
    else
      react_state = Game.react_state(game, reason)
      {:reply, {:ok, react_state}, socket}
    end
  end

  @impl true
  def handle_in("reset", _, socket) do
    game = Game.new
    socket = assign(socket, :game, game)
    react_state = Game.react_state(game, "")
    {:reply, {:ok, react_state}, socket}
  end

  defp authorized?(_payload) do
    true
  end
end
