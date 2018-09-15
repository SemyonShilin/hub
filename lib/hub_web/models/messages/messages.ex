defmodule Hub.Messages do
  use HubWeb, :model
  alias Hub.Messages.Message
  alias Hub.Users

  def list_messages do
    Repo.all(Message) |> Repo.preload(:user)
  end

  def list_messages_for_user(%{chat_id: chat_id}) do
    Repo.all from m in Message,
               join: u in assoc(m, :user),
               where: u.chat_id == ^chat_id or m.chat_room_id == ^chat_id,
               select: %{id: m.id, chat_id: u.chat_id, body: m.body, username: u.username},
               order_by: m.inserted_at
  end

  def create(attrs \\ %{}) do
    %Message{}
    |> create(attrs)
  end

  def create(message, params) do
    message
    |> Message.changeset(params)
    |> Repo.insert()
    |> case do
         {:ok, message} -> message
         {:error, changeset} -> changeset
       end
  end

  def find(%{} = params) do
    Message |> Repo.get_by(params)
  end

  def preload_for_user(%Message{} = message) do
    Repo.preload(message, :user)
  end
end
