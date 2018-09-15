defmodule Hub.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :chat_id, :integer
      add :username, :string

      timestamps()
    end
  end
end
