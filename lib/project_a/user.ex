defmodule ProjectA.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :points, :integer

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:points, :updated_at])
    |> validate_required([:points])
    |> validate_number(:points,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100,
      message: "out of range, must be between 0 and 100"
    )
  end
end
