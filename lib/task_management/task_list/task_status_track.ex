defmodule TaskManagement.TaskList.TaskStatusTrack do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_status_tracks" do
    field :status_change, :string
    field :changed_date, :date
    belongs_to :task, Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task_status_track, attrs) do
    task_status_track
    |> cast(attrs, [:status_change, :changed_date, :task_id])
    |> validate_required([:status_change, :changed_date, :task_id])
  end
end
