defmodule Flightex.Bookings.Agent do
  use Agent

  alias Flightex.Bookings.Booking

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{id: id} = booking) do
    case Agent.update(__MODULE__, &update_state(&1, booking)) do
      :ok -> {:ok, id}
      nil -> {:error, "Booking not saved"}
    end
  end

  defp update_state(state, %Booking{id: id} = booking) do
    Map.put(state, id, booking)
  end

  def get(uuid), do: Agent.get(__MODULE__, &get_booking(&1, uuid))

  defp get_booking(state, uuid) do
    case Map.get(state, uuid) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end

  def get_all, do: Agent.get(__MODULE__, & &1)
end
