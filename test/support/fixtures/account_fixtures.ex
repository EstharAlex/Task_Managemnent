defmodule TaskManagement.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskManagement.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        password: "some password",
        username: "some username"
      })
      |> TaskManagement.Account.create_user()

    user
    |> Map.put(:password, nil)
  end
end
