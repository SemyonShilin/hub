defmodule Hub.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :answered, :boolean
      add :chat_room_id, :integer

      timestamps()
    end

    alter table(:messages) do
      add :user_id, references(:users)
    end
  end
end
