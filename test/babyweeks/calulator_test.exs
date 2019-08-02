defmodule Babyweeks.CalculatorTest do
  use BabyweeksWeb.ConnCase
  alias Babyweeks.Calculator
  use ExUnit.Case

  describe "compute_weeks_and_days" do
    test "computes correct days" do
      prev = %Calculator{
        bday: Timex.to_date({2018, 9, 22})
      }

      new_calculator = Calculator.compute_weeks_and_days(prev, Timex.to_date({2019, 7, 26}))
      assert new_calculator.age_in_weeks == 43
      assert new_calculator.age_in_weeks_additional_days == 6
    end
  end

  describe "from_params" do
    test "update bday values" do
      calc = %Calculator{}
      {:ok, new_calculator} = Calculator.from_params(calc, %{"m" => 8, "d" => 12, "y" => 1984})
      assert new_calculator.bday.month == 8
      assert new_calculator.bday.day == 12
      assert new_calculator.bday.year == 1984
    end

    test "update bday values even if strings" do
      calc = %Calculator{}
      {:error, message} = Calculator.from_params(calc, %{"m" => "mon", "d" => "cow", "y" => 1984})
      assert message == "Invalid birday: Expected `1-2 digit month` at line 1, column 6."
    end
  end

  describe "handle_up when months" do
    test "bumps months of bday" do
      calc =
        %Calculator{bday: Timex.to_date({1984, 9, 2})}
        |> Calculator.handle_up(:months)

      assert calc.bday.month == 10
      assert calc.bday.day == 2
      assert calc.bday.year == 1984
    end

    test "bumps days of bday" do
      calc =
        %Calculator{bday: Timex.to_date({1984, 12, 31})}
        |> Calculator.handle_up(:days)

      assert calc.bday.month == 1
      assert calc.bday.day == 1
      assert calc.bday.year == 1985
    end

    test "bumps years of bday" do
      calc =
        %Calculator{bday: Timex.to_date({2015, 10, 21})}
        |> Calculator.handle_up(:years)

      assert calc.bday.month == 10
      assert calc.bday.day == 21
      assert calc.bday.year == 2016
    end
  end

  describe "handle_down when months" do
    test "bumps months of bday" do
      calc =
        %Calculator{bday: Timex.to_date({1984, 9, 1})}
        |> Calculator.handle_down(:months)

      assert calc.bday.month == 8
      assert calc.bday.day == 1
      assert calc.bday.year == 1984
    end
  end
end
