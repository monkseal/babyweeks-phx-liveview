defmodule BabyweeksWeb.BabyweeksLiveView do
  require Logger
  use Phoenix.LiveView

  alias Babyweeks.Calculator
  alias BabyweeksWeb.BabyweeksView

  def render(assigns) do
    BabyweeksView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    calc = %Calculator{}
    {:ok, assign(socket, calc: calc)}
  end

  def handle_event("compute", %{"bday" => bday}, socket) do
    {:noreply,
     update(socket, :calc, fn calc ->
       calc |> Calculator.from_params(bday) |> Calculator.compute_weeks_and_days()
     end)}
  end
end
