defmodule ProjectAWeb.ScoreControllerTest do
  use ProjectAWeb.ConnCase, async: false

  describe "show" do
    test "score endpoint contract", %{conn: conn} do
      conn = get(conn, Routes.score_path(conn, :show))

      assert %{"timestamp" => _, "users" => []} = json_response(conn, 200)
    end
  end
end
