defmodule Hub.Queue.Consumer do
  require Logger
  use GenServer
  alias AMQP.{Connection, Basic, Channel, Queue}
  alias Hub.MessageHandler.Producer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, rabbitmq_connect}
  end

  def handle_info({:basic_deliver, payload, meta} , state) do
    Logger.info(fn -> "Received message" end)

    Producer.publish(payload)

    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def terminate(_msg, state) do
    Connection.close(state.connection)

    {:noreply, state}
  end

  def rabbitmq_connect do
    case Connection.open(Application.get_env(:hub, :rabbitmq)) do
      {:ok, connection} ->
        Process.monitor(connection.pid)
        {:ok, channel} = Channel.open(connection)
        Queue.declare(channel, "adapter_queue")
        Basic.consume(channel, "adapter_queue", nil, no_ack: true)

        %{channel: channel, connection: connection}
      {:error, _} ->
        :timer.sleep(100)
        rabbitmq_connect()
    end
  end
end