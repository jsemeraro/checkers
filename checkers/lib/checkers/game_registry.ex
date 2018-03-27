# referenced Julia's Memory.GameRegistry
defmodule Checkers.GameRegistry do
  use Agent

  # called from application.ex
  def start_link() do
      Registry.start_link(keys: :unique, name: Checkers.GameRegistry)
  end

  # children we are going to start
  def child_spec(name) do
    defaults = %{
      id: reg(name),
      start: {Checkers.Game, :start_link, [name]},
      restart: :permanent,
      shutdown: 5000,
      type: :worker
    }
    Supervisor.child_spec(defaults, %{})
  end

  # Registers name as a unique Game - used to start Game
  def reg(name) do
    {:via, Registry, {Checkers.GameRegistry, name}}
  end

  def get_agent(name) do
    lookups = Registry.lookup(Checkers.GameRegistry, name)
    if (Enum.empty?(lookups)) do
      {:ok, pid} = start(name)
      pid
    else
      elem(List.first(lookups), 0)
    end
  end

  def save(name, game) do
    Agent.update Checkers.GameRegistry, fn state ->
      Map.put(state, name, game)
    end
  end

  # starts the Game with the given name
  def start(name) do
    case Supervisor.start_child(Checkers.Supervisor, child_spec(name)) do
      {:ok, child_pid} -> {:ok, child_pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
    end
  end

end
