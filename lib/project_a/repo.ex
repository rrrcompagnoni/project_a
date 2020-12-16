defmodule ProjectA.Repo do
  use Ecto.Repo,
    otp_app: :project_a,
    adapter: Ecto.Adapters.Postgres
end
