defmodule TaskManagement.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskManagement.TaskList.Task

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :tasks, Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :password_hash])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = cs) do
    change(cs, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp hash_password(cs), do: cs
end
