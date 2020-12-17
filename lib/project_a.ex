defmodule ProjectA do
  alias ProjectA.Repo
  alias ProjectA.User

  @spec bulk_insert_users(
          list(%{points: integer(), inserted_at: DateTime.t(), updated_at: DateTime.t()})
        ) :: :ok
  def bulk_insert_users(users_attributes \\ []) do
    Repo.transaction(fn ->
      Repo.insert_all(User, users_attributes)
    end)
    |> case do
      {:ok, _} -> :ok
    end
  end

  @spec produce_users_attributes(integer(), DateTime.t(), integer()) :: [
          %{points: integer(), inserted_at: DateTime.t(), updated_at: DateTime.t()}
        ]
  def produce_users_attributes(_, _, 0), do: []

  def produce_users_attributes(points, insert_time = %DateTime{}, seed_number)
      when is_number(points) and is_number(seed_number) do
    for _ <- 1..seed_number,
        do: %{points: points, inserted_at: insert_time, updated_at: insert_time}
  end

  @spec count_persisted_users() :: integer()
  def count_persisted_users() do
    Repo.aggregate(User, :count, :id)
  end
end
