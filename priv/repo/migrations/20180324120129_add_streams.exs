defmodule Streaming.Repo.Migrations.AddStreams do
  use Ecto.Migration

    def change do
      create table(:streams) do
        add :title, :string
        add :source, :string
        add :output, :string
        add :ffmpeg_pid, :string
        add :end_date, :datetime
        add :status, :string
      end
  end
end
