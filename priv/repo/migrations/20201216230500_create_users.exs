defmodule ProjectA.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :points, :integer, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:users, :points)
    create constraint(:users, :points_range, check: "points BETWEEN 0 AND 100")
  end
end
