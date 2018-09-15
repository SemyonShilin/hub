defmodule Hub.MessageHandler.Consumer do
  use GenStage
  alias Hub.MessageHandler.ProducerConsumer
  alias HubWeb.Endpoint
  alias Hub.Messages

  def start_link(_args) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(arg) do
    {:consumer, :some_kind_of_state, subscribe_to: [ProducerConsumer]}
  end

  def handle_events(messanges, from, state) do
    Enum.each(messanges, &push_message/1)

    {:noreply, [], state}
  end

  defp push_message(message) do
    preloaded_message = Messages.preload_for_user(message)
    Endpoint.broadcast! "messenger:lobby", "messenger:lobby:new_message", map_for_channel(preloaded_message)
  end

  defp map_for_channel(message) do
    %{body: message.body, username: message.user.username, chat_id: message.user.chat_id, id: message.id}
  end
end