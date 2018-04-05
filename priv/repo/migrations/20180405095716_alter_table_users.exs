defmodule Streaming.Repo.Migrations.AlterTableUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
          add :email, :string
          add :email_verified, :boolean
          add :token, :string


  end
  end
end
