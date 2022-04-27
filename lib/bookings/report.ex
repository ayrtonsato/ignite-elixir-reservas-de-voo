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

  def generate_report_by_date(from_date, to_date) do
    filename =
      "bookings_#{NaiveDateTime.to_string(from_date)}_#{NaiveDateTime.to_string(to_date)}.csv"

    bookings =
      BookingAgent.get_all()
      |> Map.values()
      |> Enum.filter(fn %Booking{complete_date: complete_date} ->
        compare_date(from_date, to_date, complete_date)
      end)
      |> Enum.map(fn booking -> order_string(booking) end)

    File.write!(filename, bookings)

    {:ok, "Report generated successfully"}
  end

  defp compare_date(
         from_booking_date,
         to_booking_date,
         booking_date
       ) do
    f = compare(NaiveDateTime.to_date(from_booking_date), NaiveDateTime.to_date(booking_date))

    t = compare(NaiveDateTime.to_date(booking_date), NaiveDateTime.to_date(to_booking_date))

    f_compare_date = f == :eq || f == :gt
    t_compare_date = t == :eq || t == :lt

    if f_compare_date && t_compare_date do
      true
    else
      false
    end
  end

  defp compare(date, booking) do
    date
    |> Date.compare(booking)
  end
end
