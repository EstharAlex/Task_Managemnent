defmodule TaskManagementWeb.TaskStatusTrackController do
  use TaskManagementWeb, :controller

  alias TaskManagement.TaskList
  alias TaskManagement.TaskList.TaskStatusTrack

  action_fallback TaskManagementWeb.FallbackController

  def index(conn, _params) do
    status_tracks = TaskList.list_task_status_tracks()
    render(conn, "index.json", task_status_tracks: status_tracks)
  end

  def index_for_task(conn, %{"task_id" => task_id}) do
    status_tracks = TaskList.list_task_status_track(task_id)
    render(conn, "index.json", task_status_tracks: status_tracks)
  end

  def create(conn, %{"task_status_track" => task_status_track_params}) do
    with {:ok, %TaskStatusTrack{} = task_status_track} <- TaskList.create_task_status_track(task_status_track_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/task_status_tracks/#{task_status_track}")
      |> render(:show, task_status_track: task_status_track)
    end
  end

  def show(conn, %{"id" => id}) do
    task_status_track = TaskList.get_task_status_track!(id)
    render(conn, :show, task_status_track: task_status_track)
  end

  def update(conn, %{"id" => id, "task_status_track" => task_status_track_params}) do
    task_status_track = TaskList.get_task_status_track!(id)

    with {:ok, %TaskStatusTrack{} = task_status_track} <- TaskList.update_task_status_track(task_status_track, task_status_track_params) do
      render(conn, :show, task_status_track: task_status_track)
    end
  end

  def delete(conn, %{"id" => id}) do
    task_status_track = TaskList.get_task_status_track!(id)

    with {:ok, %TaskStatusTrack{}} <- TaskList.delete_task_status_track(task_status_track) do
      send_resp(conn, :no_content, "")
    end
  end
end
