defmodule EctoDiffMigrate.TaskOutput do
  @moduledoc false
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> "" end, name: __MODULE__)
  end

  def add(line) do
    Agent.update(__MODULE__, fn _state -> line end)
  end

  def get do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
