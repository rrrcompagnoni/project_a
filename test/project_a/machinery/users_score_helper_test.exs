defmodule ProjectA.Machinery.UsersScoreHelperTest do
  use ProjectA.DataCase, async: false

  alias ProjectA.Machinery.UsersScoreHelper
  alias ProjectA.Machinery.UsersScore

  describe "points_update_frequency" do
    test "the points update frequency" do
      assert 60_000 = UsersScoreHelper.points_update_frequency()
    end
  end

  describe "update_points/3" do
    test "the new state response" do
      assert %UsersScore{max_number: 60} =
               UsersScoreHelper.update_points(
                 %UsersScore{max_number: 30, timestamp: nil},
                 DateTime.now!("Etc/UTC"),
                 60
               )
    end
  end

  describe "build_top_scorers_reply" do
    test "the update of timestamp with a new timestamp" do
      timestamp = DateTime.now!("Etc/UTC")

      assert {:reply, _, %UsersScore{timestamp: ^timestamp}} =
               UsersScoreHelper.build_top_scorers_reply(
                 %UsersScore{max_number: 30, timestamp: nil},
                 timestamp
               )
    end

    test "the response of the previous timestamp along with top scorers" do
      assert {:reply,
              %{
                timestamp: nil,
                users: []
              },
              _} =
               UsersScoreHelper.build_top_scorers_reply(
                 %UsersScore{max_number: 30, timestamp: nil},
                 DateTime.now!("Etc/UTC")
               )
    end

    test "the response of the top scores due to the limitation of max points" do
      insert_time = DateTime.now!("Etc/UTC")

      :ok =
        ProjectA.bulk_insert_users([
          %{points: 10, inserted_at: insert_time, updated_at: insert_time},
          %{points: 100, inserted_at: insert_time, updated_at: insert_time}
        ])

      assert {:reply,
              %{
                timestamp: nil,
                users: [%ProjectA.User{points: 100}]
              },
              _} =
               UsersScoreHelper.build_top_scorers_reply(
                 %UsersScore{max_number: 30, timestamp: nil},
                 DateTime.now!("Etc/UTC")
               )
    end
  end
end
