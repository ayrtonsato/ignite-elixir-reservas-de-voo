defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename) do
    bookings =
      BookingAgent.get_all()
      |> Map.values()
      |> Enum.map(fn booking -> order_string(booking) end)

    File.write!(filename, bookings)
  end

  defp order_string(%Booking{
         complete_date: complete_date,
         local_origin: local_origin,
         local_destination: local_destination,
         user_id: user_id
       }) do
    date =
      complete_date
      |> to_string()

    "#{user_id},#{local_origin},#{local_destination},#{date}"
  end
end
