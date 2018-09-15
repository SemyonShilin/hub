defmodule Hub.MessageHandler.ProducerConsumer do
  use GenStage
  alias Hub.MessageHandler.Producer
  alias Hub.Users

  def start_link(_args) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(arg) do
    {:producer_consumer, :some_kind_of_state, subscribe_to: [Producer]}
  end

  def handle_events(message, from, state) when length(message) != 0 do
    new_message = Enum.map(message, &parse_and_save_message/1)

    {:noreply, new_message, state}
  end

  def handle_events(message, _from, state), do: {:noreply, message, state}

  defp parse_and_save_message(message) do
    parsed_message = Poison.decode!(message)

    Users.create_message_for(
      %{username: username(parsed_message), chat_id: chat_id(parsed_message)},
      %{body: text(parsed_message)}
    )
  end

  defp text(message) do
    Map.get(message, "data")
    |> Map.get("message")
    |> Map.get("text")
  end

  defp username(message) do
    from =
      Map.get(message, "data")
      |> Map.get("message")
      |> Map.get("from")

    Map.get(from, "first_name") <> " " <> Map.get(from, "last_name")
  end

  defp chat_id(message) do
    Map.get(message, "data")
    |> Map.get("message")
    |> Map.get("chat")
    |> Map.get("id")
  end
end