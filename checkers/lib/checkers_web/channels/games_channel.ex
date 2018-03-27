# referenced Julia's Memory.GamesChannel
defmodule CheckersWeb.GamesChannel do
  use CheckersWeb, :channel

  alias Checkers.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Checkers.GameRegistry.get_agent(name)
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      |> assign(:player, Checkers.Game.add_user(game))
      IO.inspect(socket.assigns)
      {:ok, %{"join" => name, "game" => Game.client_view(game), "player" => socket.assigns[:player]}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("request_view", %{}, socket) do
    game = Game.client_view(socket.assigns[:game])
    {:reply, {:ok, %{ "game" => game, "player" => socket.assigns[:player] }}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("move_checker", %{"origin" => [orX, orY], "dest" => [destX, destY]}, socket) do
    player = socket.assigns[:player]

    Game.move_checker(socket.assigns[:game], {orX, orY}, {destX, destY}, player)
    game = Game.client_view(socket.assigns[:game])
    broadcast!(socket, "view", %{ "game" => game })
    {:reply, {:ok, %{ "game" => game }}, socket}
  end

  #TODO Remember to save state after a handle_in

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
