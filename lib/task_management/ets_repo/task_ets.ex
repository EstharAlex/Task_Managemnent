defmodule TaskManagement.EtsRepo.TaskEts do
  alias TaskManagement.TaskList

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :create_and_insert_tasks_ets, []},
      type: :worker,
      restart: :temporary,
      shutdown: 500
    }
  end

  # Function to insert tasks into ETS
  def create_and_insert_tasks_ets() do
    :ets.new(__MODULE__, [:public, :named_table])

    tasks = TaskList.list_tasks()
    grouped_tasks = group_tasks_by_user(tasks)

    :ets.insert(__MODULE__, grouped_tasks)

    {:ok, self()}
  end

  # Function to retrieve tasks for a user from ETS
  def get_tasks_for_user(user_id) do
    case :ets.lookup(__MODULE__, user_id) do
    [{_user_id, value}] -> value

    emp_list -> emp_list
    end
  end

  # Function to add new task for a user from ETS
 def add_new_tasks_for_user(user_id, task) do
   tasks = get_tasks_for_user(user_id)
   new_list = [task | tasks] |> Enum.uniq()
   :ets.insert(__MODULE__, {user_id, new_list})
 end

  # Function to add new task for a user from ETS
 def update_tasks_for_user(user_id, task) do
   tasks = get_tasks_for_user(user_id)
   updated_list =
      Enum.map(tasks, fn x ->
          if x.id == task.id do
          task
          else
            x
          end
      end)
    :ets.insert(__MODULE__, {user_id, updated_list})
 end

  # Function to delete tasks for a user from ETS
  def delete_tasks_for_user(user_id) do
    :ets.delete(__MODULE__, user_id)
  end

  # Function to delete a specific task for a user from ETS
  def delete_task_for_user(user_id, task_id) do
    tasks = get_tasks_for_user(user_id)
    new_list = Enum.reject(tasks, fn x -> x.id == task_id end)
    :ets.insert(__MODULE__, {user_id, new_list})
  end

  # Function to group tasks by user ID
  def group_tasks_by_user(tasks) do
    Enum.group_by(tasks, &(&1.user_id))
    |> Enum.into([])
  end

end
