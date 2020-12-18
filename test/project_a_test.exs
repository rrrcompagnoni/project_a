defmodule ProjectATest do
  use ProjectA.DataCase, async: false

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

  describe "update_users_points/1" do
    test "all users points are updating" do
      insert_time = DateTime.now!("Etc/UTC")

      :ok =
        ProjectA.bulk_insert_users([
          %{points: 0, inserted_at: insert_time, updated_at: insert_time},
          %{points: 0, inserted_at: insert_time, updated_at: insert_time}
        ])

      update_at = DateTime.now!("Etc/UTC")

      assert :ok = ProjectA.update_users_points(update_at)

      [scorer_a, scorer_b] = ProjectA.list_users()

      assert scorer_a.updated_at == update_at
      assert scorer_b.updated_at == update_at
    end
  end

  describe "list_top_scorers/1" do
    test "the minimum score to be considered" do
      insert_time = DateTime.now!("Etc/UTC")

      :ok =
        ProjectA.bulk_insert_users([
          %{points: 30, inserted_at: insert_time, updated_at: insert_time},
          %{points: 90, inserted_at: insert_time, updated_at: insert_time}
        ])

      [scorer] = ProjectA.list_top_scorers(50)

      assert scorer.points == 90
    end

    test "the order of points" do
      insert_time = DateTime.now!("Etc/UTC")

      :ok =
        ProjectA.bulk_insert_users([
          %{points: 15, inserted_at: insert_time, updated_at: insert_time},
          %{points: 30, inserted_at: insert_time, updated_at: insert_time},
          %{points: 90, inserted_at: insert_time, updated_at: insert_time}
        ])

      [scorer_a, scorer_b] = ProjectA.list_top_scorers(10)

      assert scorer_a.points == 90
      assert scorer_b.points == 30
    end

    test "the size of the list of the top scorers" do
      insert_time = DateTime.now!("Etc/UTC")

      :ok =
        ProjectA.bulk_insert_users([
          %{points: 15, inserted_at: insert_time, updated_at: insert_time},
          %{points: 30, inserted_at: insert_time, updated_at: insert_time},
          %{points: 90, inserted_at: insert_time, updated_at: insert_time}
        ])

      [_, _] = ProjectA.list_top_scorers(10)
    end
  end

  describe "generate_score" do
    test "the score generation behavior, it never goes far from 100 and generate a 0 score" do
      assert Enum.filter(1..150, fn _ -> ProjectA.generate_score() > 100 end) == []
    end
  end
end
