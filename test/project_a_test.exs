defmodule ProjectATest do
  use ProjectA.DataCase, async: true

  describe "bulk_insert_users/1" do
    test "the transaction rollback" do
      assert_raise Postgrex.Error, fn ->
        insert_time = DateTime.now!("Etc/UTC")

        ProjectA.bulk_insert_users([
          %{points: nil, inserted_at: nil, updated_at: nil},
          %{points: 0, inserted_at: insert_time, updated_at: insert_time}
        ])
      end

      assert ProjectA.count_persisted_users() == 0
    end

    test "a success bulk insert" do
      insert_time = DateTime.now!("Etc/UTC")

      users_attributes = ProjectA.produce_users_attributes(0, insert_time, 4)

      assert :ok = ProjectA.bulk_insert_users(users_attributes)
    end
  end

  describe "produce_users_attributes/2" do
    test "0 seed" do
      default_points = 0
      insert_time = DateTime.now!("Etc/UTC")

      assert [] = ProjectA.produce_users_attributes(default_points, insert_time, 0)
    end

    test "3 seeds" do
      default_points = 0
      insert_time = DateTime.now!("Etc/UTC")

      assert [
               %{points: ^default_points, inserted_at: ^insert_time, updated_at: ^insert_time},
               %{points: ^default_points, inserted_at: ^insert_time, updated_at: ^insert_time},
               %{points: ^default_points, inserted_at: ^insert_time, updated_at: ^insert_time}
             ] = ProjectA.produce_users_attributes(default_points, insert_time, 3)
    end
  end
end
