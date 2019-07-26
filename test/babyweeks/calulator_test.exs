defmodule Babyweeks.Calculator do
  use BabyweeksWeb.ConnCase

  describe "compute_weeks_and_days" do
    test "computes correct days", %{html: html} do
      assert Calculator.compute_weeks_and_days() == 0
    end
  end
end
