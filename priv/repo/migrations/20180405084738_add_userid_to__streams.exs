defmodule Streaming.Repo.Migrations.AddUseridToStreams do
  use Ecto.Migration

  def change do
    alter table(:streams) do
      add :user_id, references(:users)
  end


  end
end
