defmodule TaskManagementWeb.TaskController do
  use TaskManagementWeb, :controller

  alias TaskManagement.EtsRepo.TaskEts
  alias TaskManagement.TaskList
  alias TaskManagement.TaskList.Task

  action_fallback TaskManagementWeb.FallbackController

  def list(conn, _params) do
    tasks = TaskList.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def index(conn, %{"user_id" => user_id}) do
    tasks = TaskEts.get_tasks_for_user(String.to_integer(user_id))
    render(conn, :index, tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- TaskList.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tasks/#{task}")
      |> render(:show, task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = TaskList.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = TaskList.get_task!(id)

    with {:ok, %Task{} = task} <- TaskList.update_task(task, task_params) do
      render(conn, :show, task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = TaskList.get_task!(id)
    with {:ok, %Task{}} <- TaskList.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end

end
