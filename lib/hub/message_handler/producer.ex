defmodule Hub.MessageHandler.Producer do
  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    state = %{events: [], demand: 0}

    {:producer, state, []}
  end

  def publish(message) do
    GenStage.cast(__MODULE__, {:message, message})
  end

  def handle_cast({:message, message}, state) do
    {:noreply, [message], state}
  end

  def handle_demand(demand, state), do: {:noreply, [], state}
end