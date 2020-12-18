defmodule ProjectA.Machinery.UsersScore do
  @enforce_keys [:max_number, :timestamp]

  defstruct max_number: 0, timestamp: nil

  use GenServer

  alias ProjectA.Machinery.UsersScoreHelper

  def start_link(max_number)
      when is_number(max_number) do
    GenServer.start_link(__MODULE__, %__MODULE__{max_number: max_number, timestamp: nil},
      name: __MODULE__
    )
  end

  def top_scorers do
    GenServer.call(__MODULE__, :top_scorers)
  end

  @impl true
  def init(%__MODULE__{} = initial_state) do
    schedule_points_update()

    {:ok, initial_state}
  end

  @impl true
  def handle_call(:top_scorers, _from, current_state) do
    UsersScoreHelper.build_top_scorers_reply(current_state, DateTime.now!("Etc/UTC"))
  end

  @impl true
  def handle_info(:update_points, current_state) do
    new_state =
      UsersScoreHelper.update_points(
        current_state,
        DateTime.now!("Etc/UTC"),
        ProjectA.generate_score()
      )

    schedule_points_update()

    {:noreply, new_state}
  end

  defp schedule_points_update do
    Process.send_after(self(), :update_points, UsersScoreHelper.points_update_frequency())
  end
end
