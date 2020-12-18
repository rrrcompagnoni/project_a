defmodule ProjectAWeb.ScoreController do
  use ProjectAWeb, :controller

  plug :put_format, "json"

  def show(conn, _) do
    json(conn, ProjectA.top_scorers())
  end
end
