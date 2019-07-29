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
    {:ok, assign(socket, calc: calc, error: nil)}
  end

  @spec handle_event(<<_::16, _::_*8>>, any, Phoenix.LiveView.Socket.t()) :: {:noreply, any}
  def handle_event("compute", %{"bday" => bday}, %{assigns: assigns} = socket) do
    case Calculator.from_params(assigns.calc, bday) do
      {:ok, updated_calc} ->
        {:noreply,
        assign(socket, error: nil, calc: Calculator.compute_weeks_and_days(updated_calc))
        }

      {:error, message} ->
        {:noreply,
         assign(socket, error: message)}
    end
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
