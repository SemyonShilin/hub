defmodule Hub.Queue.Producer do
  @moduledoc false

  use GenServer
  alias AMQP.{Connection, Basic, Channel, Queue}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, rabbitmq_connect()}
  end

  def publish(%{} = message) do
    GenServer.call(__MODULE__, message)
  end

  def handle_call(%{} = message, _from, state) do
    {:reply, call_adapter(%{message: message, state: state}), state}
  end

  def terminate(_msg, state) do
    Connection.close(state.connection)

    {:noreply, state}
  end

  def call_adapter(%{message: message, state: state}) do
    Basic.publish state.channel, "", "hub_queue", Poison.encode!(message)
    :ok
  end

  def rabbitmq_connect do
    case Connection.open(port: 5672) do
      {:ok, connection} ->
        Process.monitor(connection.pid)
        {:ok, channel} = Channel.open(connection)
        Queue.declare(channel, "hub_queue")

        %{channel: channel, connection: connection}
      {:error, _} ->
        :timer.sleep(10000)
        rabbitmq_connect()
    end
  end
end
