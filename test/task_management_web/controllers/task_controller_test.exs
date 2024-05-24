defmodule TaskManagementWeb.TaskControllerTest do
  use TaskManagementWeb.ConnCase

  import TaskManagement.TaskListFixtures
  import TaskManagement.AccountFixtures

  alias TaskManagement.TaskList.Task

  @create_attrs %{
    status: "TO DO",
    description: "some description",
    title: "some title",
    due_date: ~D[2024-05-22],
    user_id: 1
  }
  @update_attrs %{
    status: "DONE",
    description: "some updated description",
    title: "some updated title",
    due_date: ~D[2024-05-23]
  }
  @invalid_attrs %{status: nil, description: nil, title: nil, due_date: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, ~p"/api/tasks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn} do
      user = user_fixture()
      user_id = user.id
      task_attrs = Map.put(@create_attrs, :user_id, user.id)
      conn = post(conn, ~p"/api/tasks", task: task_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/tasks/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "due_date" => "2024-05-22",
               "status" => "TO DO",
               "title" => "some title",
               "user_id" => ^user_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks", task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:create_task]

    test "renders task when data is valid", %{conn: conn, task: %Task{id: id} = task} do
      conn = put(conn, ~p"/api/tasks/#{task}", task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/tasks/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "due_date" => "2024-05-23",
               "status" => "DONE",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, ~p"/api/tasks/#{task}", task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, ~p"/api/tasks/#{task}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tasks/#{task}")
      end
    end
  end

  defp create_task(_) do
    user = user_fixture()
    task = task_fixture(%{user_id: user.id})

    %{task: task}
  end
end
