defmodule Hub.Users do
  use HubWeb, :model
  alias Hub.Users.User

  def find_or_create(params) do
    case Hub.Users.find(params) do
      %User{} = user -> user
      nil -> Hub.Users.create(params)
    end
  end

  def message_build(user, params) do
    Ecto.build_assoc(user, :messages, params)
    |> Repo.insert!()
  end

  def find(%{} = params) do
    User |> Repo.get_by(params)
  end

  def create(attrs \\ %{}) do
    %User{}
    |> create(attrs)
  end

  def create(user, params) do
    user
    |> User.changeset(params)
    |> Repo.insert()
    |> case do
         {:ok, user} -> user
         {:error, changeset} -> changeset
       end
  end

  def create_message_for(%{} = user_params, %{} = message_params) do
    Hub.Users.find_or_create(user_params)
    |> Hub.Users.message_build(message_params)
  end
end
