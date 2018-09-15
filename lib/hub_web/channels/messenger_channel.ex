defmodule Hub.MessengerChannel do
  use HubWeb, :channel
  alias Hub.{Users, Messages}
  alias Hub.Queue.Producer

  def join(channel_name, _params, socket) do
    case socket.assigns.chat_id do
      chat_id when is_integer(chat_id) ->
        send(self(), :after_join)
        {:ok, %{channel: channel_name}, socket}
      _ ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("message:add", %{"message" => body} = data, %{assigns: %{chat_id: chat_id}} = socket) do
    Users.create_message_for(%{username: "Admin", chat_id: 1}, %{body: body, chat_room_id: chat_id})

    Producer.publish(
      %{data:
        %{chat: %{id: chat_id},
          messages: [%{body: body,
                       menu: %{items: [], type: "inline"}}]
        }
      }
    )

    push(socket, "messenger:lobby:new_message", %{body: body, username: "Admin", chat_id: 1})

    {:reply, :ok, socket}
  end

  def handle_info(:after_join, socket) do
    messages = Messages.list_messages_for_user(%{chat_id: socket.assigns.chat_id})

    push(socket, "messenger:lobby:all_messages", %{messages: messages})

    {:noreply, socket}
  end

  def handle_info({:push, message}, socket) do
    push(socket, "messenger:lobby:new_message",
      %{body: message.body, username: message.username, chat_id: message.user.chat_id, id: message.id})

    {:noreply, socket}
  end

  def push_new_message(message) do
    send(self(), {:push, message})
  end
end
