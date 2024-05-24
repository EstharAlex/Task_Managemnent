defmodule TaskManagement.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :due_date, :date
      add :status, :string, default: "TO DO"
      add :user_id, references(:users, on_delete: :nothing)


      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:user_id])
  end
end
