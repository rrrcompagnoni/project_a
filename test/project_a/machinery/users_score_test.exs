defmodule ProjectA.Machinery.UsersScoreTest do
  use ProjectA.DataCase, async: false

  alias ProjectA.Machinery.UsersScore

  describe "top_scorers" do
    test "the response contract" do
      assert %{
               timestamp: _,
               users: _
             } = UsersScore.top_scorers()
    end
  end
end
