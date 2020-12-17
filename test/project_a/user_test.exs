defmodule UserTest do
  use ExUnit.Case, async: true

  alias ProjectA.User

  describe "changeset/2" do
    test "null fields" do
      changeset = User.changeset(%User{}, %{points: nil})

      assert changeset.errors[:points] == {"can't be blank", [validation: :required]}
    end

    test "points range" do
      changeset = User.changeset(%User{}, %{points: -1})

      assert changeset.errors[:points] ==
               {"out of range, must be between 0 and 100",
                [{:validation, :number}, {:kind, :greater_than_or_equal_to}, {:number, 0}]}

      changeset = User.changeset(%User{}, %{points: 0})

      assert changeset.errors[:points] == nil

      changeset = User.changeset(%User{}, %{points: 100})

      assert changeset.errors[:points] == nil

      changeset = User.changeset(%User{}, %{points: 101})

      assert changeset.errors[:points] ==
               {"out of range, must be between 0 and 100",
                [{:validation, :number}, {:kind, :less_than_or_equal_to}, {:number, 100}]}
    end
  end
end
