defmodule TaskManagementWeb.TaskStatusTrackJSON do
  alias TaskManagement.TaskList.TaskStatusTrack

  @doc """
  Renders a list of task_status_tracks.
  """
  def index(%{task_status_tracks: task_status_tracks}) do
    %{data: for(task_status_track <- task_status_tracks, do: data(task_status_track))}
  end

  @doc """
  Renders a single task_status_track.
  """
  def show(%{task_status_track: task_status_track}) do
    %{data: data(task_status_track)}
  end

  defp data(%TaskStatusTrack{} = task_status_track) do
    %{
      id: task_status_track.id,
      status_change: task_status_track.status_change,
      changed_date: task_status_track.changed_date,
      task_id: task_status_track.task_id
    }
  end
end
