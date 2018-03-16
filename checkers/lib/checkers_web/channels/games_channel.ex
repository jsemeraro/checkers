defmodule CheckersWeb.GamesChannel do
  use CheckersWeb, :channel

  alias Checkers.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Checkers.GameBackup.load(name) || Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  #TODO Remember to save state after a handle_in

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
