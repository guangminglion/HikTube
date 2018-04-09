defmodule Streaming.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
 alias Streaming.Stream

  schema "users" do
    field :password, :string
    field :username, :string

    field :email, :string, unique: true
    field :email_verified, :boolean
    field :token, :string
    timestamps()

    has_many :streams, Streaming.Stream

  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
  change(changeset, password: Bcrypt.hashpwsalt(password))
    end
defp put_pass_hash(changeset), do: changeset
end
