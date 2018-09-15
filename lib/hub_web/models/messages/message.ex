defmodule Hub.Messages.Message do
  use HubWeb, :model

  schema "messages" do
    field :body, :string
    field :answered, :boolean
    field :chat_room_id, :integer
    belongs_to :user, Hub.Users.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body])
    |> validate_required([:body])
  end
end
