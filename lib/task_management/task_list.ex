defmodule TaskManagement.TaskList do
  @moduledoc """
  The TaskList context.
  """

  import Ecto.Query, warn: false
  alias TaskManagement.Repo
  # alias TaskManagement.Account.User
  alias TaskManagement.EtsRepo.TaskEts
  alias TaskManagement.TaskList.{Task, TaskStatusTrack}

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  def list_task_from_user(user_id) do
    from(t in Task, where: t.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, task} ->
        TaskEts.add_new_tasks_for_user(task.user_id, task)
        status_track_for_task(task)
        {:ok, task}

      error -> error
    end
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, task} ->
        TaskEts.update_tasks_for_user(task.user_id, task)
        status_track_for_task(task)
        {:ok, task}

      error -> error
    end
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    TaskEts.delete_task_for_user(task.user_id, task.id)
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  alias TaskManagement.TaskList.TaskStatusTrack

  @doc """
  Returns the list of task_status_tracks.

  ## Examples

      iex> list_task_status_tracks()
      [%TaskStatusTrack{}, ...]

  """
  def list_task_status_tracks do
    Repo.all(TaskStatusTrack)
  end

  def list_task_status_track(task_id) do
    from(tst in TaskStatusTrack, where: tst.task_id == ^task_id)
    |> Repo.all()
  end

  defp status_track_for_task(%Task{id: task_id, status: status_change}) do
    %TaskStatusTrack{
      status_change: status_change,
      changed_date: Date.utc_today(),
      task_id: task_id
    }
    |> TaskStatusTrack.changeset(%{})
    |> Repo.insert()
  end

  @doc """
  Gets a single task_status_track.

  Raises `Ecto.NoResultsError` if the Task status track does not exist.

  ## Examples

      iex> get_task_status_track!(123)
      %TaskStatusTrack{}

      iex> get_task_status_track!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task_status_track!(id), do: Repo.get!(TaskStatusTrack, id)

  @doc """
  Creates a task_status_track.

  ## Examples

      iex> create_task_status_track(%{field: value})
      {:ok, %TaskStatusTrack{}}

      iex> create_task_status_track(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_status_track(attrs \\ %{}) do
    %TaskStatusTrack{}
    |> TaskStatusTrack.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task_status_track.

  ## Examples

      iex> update_task_status_track(task_status_track, %{field: new_value})
      {:ok, %TaskStatusTrack{}}

      iex> update_task_status_track(task_status_track, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_status_track(%TaskStatusTrack{} = task_status_track, attrs) do
    task_status_track
    |> TaskStatusTrack.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task_status_track.

  ## Examples

      iex> delete_task_status_track(task_status_track)
      {:ok, %TaskStatusTrack{}}

      iex> delete_task_status_track(task_status_track)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_status_track(%TaskStatusTrack{} = task_status_track) do
    Repo.delete(task_status_track)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_status_track changes.

  ## Examples

      iex> change_task_status_track(task_status_track)
      %Ecto.Changeset{data: %TaskStatusTrack{}}

  """
  def change_task_status_track(%TaskStatusTrack{} = task_status_track, attrs \\ %{}) do
    TaskStatusTrack.changeset(task_status_track, attrs)
  end
end
