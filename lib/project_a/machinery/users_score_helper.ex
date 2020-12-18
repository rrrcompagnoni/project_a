defmodule ProjectA.Machinery.UsersScoreHelper do
  alias ProjectA.Machinery.UsersScore

  def points_update_frequency do
    60_000
  end

  def build_initial_state(initial_score) do
    %UsersScore{timestamp: nil, max_number: initial_score}
  end

  def update_points(%UsersScore{} = machine_state, %DateTime{} = timestamp, max_number)
      when is_number(max_number) do
    :ok = ProjectA.update_users_points(timestamp)

    %{machine_state | max_number: max_number}
  end

  def build_top_scorers_reply(%UsersScore{} = machine_state, %DateTime{} = timestamp) do
    new_state = %{machine_state | timestamp: timestamp}

    reply = %{
      timestamp: machine_state.timestamp,
      users: ProjectA.list_top_scorers(machine_state.max_number)
    }

    {:reply, reply, new_state}
  end
end
