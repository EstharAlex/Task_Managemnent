defmodule TaskManagement.TaskListFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskManagement.TaskList` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_date: ~D[2024-05-22],
        status: "TO DO",
        title: "some title",
        user_id: 1
      })
      |> TaskManagement.TaskList.create_task()

    task
  end

  @doc """
  Generate a task_status_track.
  """
  def task_status_track_fixture(attrs \\ %{}) do
    {:ok, task_status_track} =
      attrs
      |> Enum.into(%{
        changed_date: ~D[2024-05-22],
        status_change: "some status_change",
        task_id: 42
      })
      |> TaskManagement.TaskList.create_task_status_track()

    task_status_track
  end
end
