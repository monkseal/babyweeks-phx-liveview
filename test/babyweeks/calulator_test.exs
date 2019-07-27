defmodule Babyweeks.CalculatorTest do
  use BabyweeksWeb.ConnCase
  alias Babyweeks.Calculator
  use ExUnit.Case

  describe "compute_weeks_and_days" do
    test "computes correct days" do
      prev = %Calculator{
        bday_month: 9,
        bday_year: 2018,
        bday_day: 22
      }

      new_calculator = Calculator.compute_weeks_and_days(prev, Timex.to_date({2019, 7, 26}))
      assert new_calculator.weeks == 43
      assert new_calculator.days == 6
    end
  end

  describe "from_params" do
    test "update bday values" do
      calc = %Calculator{}
      new_calculator = Calculator.from_params(calc, %{"m" => 8, "d" => 12, "y" => 1984})
      assert new_calculator.bday_month == 8
      assert new_calculator.bday_day == 12
      assert new_calculator.bday_year == 1984
    end

    test "update bday values even if strings" do
      calc = %Calculator{}
      new_calculator = Calculator.from_params(calc, %{"m" => "mon", "d" => "cow", "y" => 1984})
      assert new_calculator.bday_month == "mon"
      assert new_calculator.bday_day == "cow"
      assert new_calculator.bday_year == 1984
    end
  end

  describe "handle_up when months" do
    test "bumps months of bday" do
      calc =
        %Calculator{}
        |> Calculator.from_params(%{"m" => 9, "d" => 2, "y" => 1984})
        |> Calculator.handle_up(:months)

      assert calc.bday_month == 10
      assert calc.bday_day == 2
      assert calc.bday_year == 1984
    end

    test "bumps days of bday" do
      calc =
        %Calculator{}
        |> Calculator.from_params(%{"m" => 12, "d" => 31, "y" => 1984})
        |> Calculator.handle_up(:days)

      assert calc.bday_month == 1
      assert calc.bday_day == 1
      assert calc.bday_year == 1985
    end

    test "bumps years of bday" do
      calc =
        %Calculator{}
        |> Calculator.from_params(%{"m" => 10, "d" => 21, "y" => 2015})
        |> Calculator.handle_up(:years)

      assert calc.bday_month == 10
      assert calc.bday_day == 21
      assert calc.bday_year == 2016
    end
  end

  describe "handle_down when months" do
    test "bumps months of bday" do
      calc =
        %Calculator{}
        |> Calculator.from_params(%{"m" => 9, "d" => 2, "y" => 1984})
        |> Calculator.handle_down(:months)

      assert calc.bday_month == 8
      assert calc.bday_day == 2
      assert calc.bday_year == 1984
    end
  end
end
