# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate_report_by_date/2" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      booking1 = %{
        complete_date: ~N[2021-01-01 12:00:00],
        local_origin: "São Paulo",
        local_destination: "Rio de Janeiro",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      booking2 = %{
        complete_date: ~N[2020-01-01 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Porto Alegre",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      Flightex.create_or_update_booking(booking1)
      Flightex.create_or_update_booking(booking2)

      from_date = ~N[2020-12-31 12:00:00]
      to_date = ~N[2021-10-01 12:00:00]

      Report.generate_report_by_date(
        from_date,
        to_date
      )

      {:ok, file} =
        File.read(
          "bookings_#{NaiveDateTime.to_string(from_date)}_#{NaiveDateTime.to_string(to_date)}.csv"
        )

      content = "12345678900,Brasilia,Porto Alegre,2020-01-01 12:00:00"

      assert file =~ content
    end
  end
end
