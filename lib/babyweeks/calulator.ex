defmodule Babyweeks.Calculator do
  defstruct bday_month: 0,
            bday_year: 0,
            bday_day: 0,
            days: 0,
            weeks: 0,
            age_in_months: 0,
            age_in_years: 0,
            age_in_days: 0,
            error: nil,
            today: nil

  @spec from_params(%{bday_day: any, bday_month: any, bday_year: any}, nil | keyword | map) :: %{
          bday_day: any,
          bday_month: any,
          bday_year: any
        }
  def from_params(calc, bday) do
    %{calc | bday_month: bday["m"], bday_year: bday["y"], bday_day: bday["d"]}
  end

  def default_bday_to_today(calc) do
    %{calc | today: today(), bday_month: today().month, bday_year: today().year, bday_day: today().day}
  end

  def today do
    Timex.local() |> Timex.to_date()
  end

  def compute_weeks_and_days(calc, end_date \\ today()) do
    case Timex.parse("#{calc.bday_year}-#{calc.bday_month}-#{calc.bday_day}", "{YYYY}-{M}-{D}") do
      {:ok, start_date} ->
        calc
        |> compute_weeks(end_date, start_date)
        |> compute_days(end_date, start_date)
        |> compute_age_in_days(end_date, start_date)
        |> compute_age_in_months(end_date, start_date)
        |> compute_age_in_years(end_date, start_date)
        |> no_error

      {:error, message} ->
        calc |> invalid_date_error(message) |> clear_days_weeks
    end
  end

  def no_error(calc) do
    %{calc | error: nil}
  end

  def compute_weeks(calc, end_date, start_date) do
    %{calc | weeks: Timex.diff(end_date, start_date, :weeks)}
  end

  def compute_days(calc, end_date, start_date) do
    days = Timex.diff(end_date, start_date, :days)
    weeks = Timex.diff(end_date, start_date, :weeks)

    %{calc | days: days - weeks * 7}
  end

  def compute_age_in_days(calc, end_date, start_date) do
    %{calc | age_in_days: Timex.diff(end_date, start_date, :days)}
  end

  def compute_age_in_months(calc, end_date, start_date) do
    %{calc | age_in_months: Timex.diff(end_date, start_date, :months)}
  end

  def compute_age_in_years(calc, end_date, start_date) do
    %{calc | age_in_years: Timex.diff(end_date, start_date, :years)}
  end

  def invalid_date_error(calc, message) do
    %{calc | error: "Invalid birday: #{message}"}
  end

  def clear_days_weeks(calc) do
    %{calc | weeks: 0, days: 0}
  end
end
