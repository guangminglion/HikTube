defmodule Streaming.Repo.Migrations.AlterStreamsDefaultTime do
  use Ecto.Migration

  def change do
    alter table(:streams) do
          remove :start_time
          add :created_at, :timestamptz          
timestamps(updated_at: false, type: :timestamptz)

  end
end
end
