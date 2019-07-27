defmodule BabyweeksWeb.BabyweeksLiveView do
  require Logger
  use Phoenix.LiveView

  alias Babyweeks.Calculator
  alias BabyweeksWeb.BabyweeksView

  def render(assigns) do
    BabyweeksView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    calc = Calculator.default_bday_to_today(%Calculator{})
    {:ok, assign(socket, calc: calc)}
  end

  def handle_event("compute", %{"bday" => bday}, socket) do
    {:noreply,
     update(socket, :calc, fn calc ->
       calc |> Calculator.from_params(bday) |> Calculator.compute_weeks_and_days()
     end)}
  end

  def handle_event("up", value, socket) do
    interval = String.to_existing_atom(value)

    {:noreply,
     update(socket, :calc, fn calc ->
       calc |> Calculator.handle_up(interval) |> Calculator.compute_weeks_and_days()
     end)}
  end

  def handle_event("down", value, socket) do
    interval = String.to_existing_atom(value)

    {:noreply,
     update(socket, :calc, fn calc ->
       calc |> Calculator.handle_down(interval) |> Calculator.compute_weeks_and_days()
     end)}
  end
end
