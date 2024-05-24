defmodule TaskManagementWeb.TaskStatusTrackControllerTest do
  use TaskManagementWeb.ConnCase

  import TaskManagement.TaskListFixtures

  alias TaskManagement.TaskList.TaskStatusTrack

  @create_attrs %{
    status_change: "some status_change",
    changed_date: ~D[2024-05-22],
    task_id: 42
  }
  @update_attrs %{
    status_change: "some updated status_change",
    changed_date: ~D[2024-05-23],
    task_id: 43
  }
  @invalid_attrs %{status_change: nil, changed_date: nil, task_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list" do
    test "lists all task_status_tracks", %{conn: conn} do
      conn = get(conn, ~p"/api/task_status_tracks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task_status_track" do
    test "renders task_status_track when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/task_status_tracks", task_status_track: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/task_status_tracks/#{id}")

      assert %{
               "id" => ^id,
               "changed_date" => "2024-05-22",
               "status_change" => "some status_change",
               "task_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/task_status_tracks", task_status_track: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task_status_track" do
    setup [:create_task_status_track]

    test "renders task_status_track when data is valid", %{conn: conn, task_status_track: %TaskStatusTrack{id: id} = task_status_track} do
      conn = put(conn, ~p"/api/task_status_tracks/#{task_status_track}", task_status_track: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/task_status_tracks/#{id}")

      assert %{
               "id" => ^id,
               "changed_date" => "2024-05-23",
               "status_change" => "some updated status_change",
               "task_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task_status_track: task_status_track} do
      conn = put(conn, ~p"/api/task_status_tracks/#{task_status_track}", task_status_track: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task_status_track" do
    setup [:create_task_status_track]

    test "deletes chosen task_status_track", %{conn: conn, task_status_track: task_status_track} do
      conn = delete(conn, ~p"/api/task_status_tracks/#{task_status_track}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/task_status_tracks/#{task_status_track}")
      end
    end
  end

  defp create_task_status_track(_) do
    task_status_track = task_status_track_fixture()
    %{task_status_track: task_status_track}
  end
end
