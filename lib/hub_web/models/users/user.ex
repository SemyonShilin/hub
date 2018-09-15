defmodule Hub.Users.User do
  use HubWeb, :model

  schema "users" do
    field :chat_id, :integer
    field :username, :string
    has_many :messages, Hub.Messages.Message

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:chat_id, :username])
    |> validate_required([:chat_id, :username])
  end
end
