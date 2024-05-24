defmodule TaskManagement.Repo.Migrations.CreateTaskStatusTracks do
  use Ecto.Migration

  def change do
    create table(:task_status_tracks) do
      add :status_change, :string
      add :changed_date, :date
      add :task_id, :integer

      timestamps(type: :utc_datetime)
    end
    create index(:task_status_tracks, [:task_id])
  end
end
