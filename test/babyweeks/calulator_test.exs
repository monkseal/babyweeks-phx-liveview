defmodule Babyweeks.CalculatorTest do
  use BabyweeksWeb.ConnCase
  alias Babyweeks.Calculator
  use ExUnit.Case

  describe "compute_weeks_and_days" do
    test "computes correct days" do
      prev = %Calculator{}
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
end
