defmodule Babyweeks.Calculator do
  defstruct bday: nil,
            days: 0,
            weeks: 0,
            age_in_months: 0,
            age_in_years: 0,
            age_in_days: 0,
            today: nil

  @spec from_params(%{bday_day: any, bday_month: any, bday_year: any}, nil | keyword | map) :: %{
          bday_day: any,
          bday_month: any,
          bday_year: any
        }
  def from_params(calc, bday) do
    case Timex.parse("#{bday["y"]}-#{bday["m"]}-#{bday["d"]}", "{YYYY}-{M}-{D}") do
      {:ok, bday} ->
        new_calc = %{calc | bday: bday }
        {:ok, new_calc }
      {:error, message} ->
        {:error, invalid_date_error(message) }
    end
  end

  def default_bday_to_today(calc) do
    %{
      calc
      | today: today(),
        bday: today()
    }
  end

  def today do
    Timex.local() |> Timex.to_date()
  end

  def compute_weeks_and_days(calc, end_date \\ today()) do
    calc
    |> compute_weeks(end_date, calc.bday)
    |> compute_days(end_date, calc.bday)
    |> compute_age_in_days(end_date, calc.bday)
    |> compute_age_in_months(end_date, calc.bday)
    |> compute_age_in_years(end_date, calc.bday)
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

  def invalid_date_error(message) do
     "Invalid birday: #{message}"
  end

  def clear_days_weeks(calc) do
    %{calc | weeks: 0, days: 0}
  end

  def handle_up(calc, interval \\ :days) do

    options = [{interval, 1}]
    shift_bday(calc, calc.bday, options)
  end

  def handle_down(calc, interval \\ :days) do
    options = [{interval, -1}]
    shift_bday(calc, calc.bday, options)
  end

  def shift_bday(calc, bday, shift_options) do
    shifted = Timex.shift(bday, shift_options)
    %{calc | bday: shifted}
  end
end
