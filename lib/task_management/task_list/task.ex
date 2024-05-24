defmodule TaskManagement.TaskList.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias TaskManagement.Account.User

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, :string, default: "TO DO"
    field :due_date, :date
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :due_date, :status, :user_id])
    |> validate_required([:title, :status, :user_id, :due_date])
    |> validate_inclusion(:status, ["TO DO", "IP", "DONE"])
    |> assoc_constraint(:user)
  end

end
