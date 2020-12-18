defmodule ProjectA do
  import Ecto.Query, only: [from: 2]

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

  @spec list_users() :: list(Uset.t())
  def list_users() do
    Repo.all(User)
  end

  @spec update_users_points(DateTime.t()) :: :ok
  def update_users_points(%DateTime{} = update_at) do
    Repo.transaction(fn ->
      User
      |> Repo.stream()
      |> Enum.map(&update_user_points(&1, update_at, generate_score()))
    end)
    |> case do
      {:ok, _} ->
        :ok
    end
  end

  @spec top_scorers() :: %{
          timestamp: DateTime.t() | nil,
          users: list(User.t())
        }
  def top_scorers() do
    ProjectA.Machinery.UsersScore.top_scorers()
  end

  @spec list_top_scorers(integer()) :: [User.t()]
  def list_top_scorers(minimum_score) when is_number(minimum_score) do
    query =
      from u in User,
        where: u.points > ^minimum_score,
        limit: 2,
        order_by: [desc: :points]

    Repo.all(query)
  end

  @spec generate_score() :: integer()
  def generate_score() do
    Enum.random(0..100)
  end

  defp update_user_points(user, update_at, points) do
    user
    |> User.changeset(%{points: points, updated_at: update_at})
    |> Repo.update!()
  end
end
