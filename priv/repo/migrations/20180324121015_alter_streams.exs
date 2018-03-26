defmodule Streaming.Repo.Migrations.AlterStreams do
  use Ecto.Migration

  def change do
    alter table(:streams) do
          remove :end_date
          add :start_time, :utc_datetime
  end
end
end
