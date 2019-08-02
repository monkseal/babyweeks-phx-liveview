defmodule BabyweeksWeb.BabyweeksLiveView do
  use Phoenix.LiveView

  alias Babyweeks.Calculator
  alias BabyweeksWeb.BabyweeksView
  alias Babyweeks.Links

  def render(assigns) do
    BabyweeksView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    calc = Calculator.default_bday_to_today(%Calculator{})
    {:ok, assign(socket, calc: calc, links: [], error: nil)}
  end

  @spec handle_event(<<_::16, _::_*8>>, any, Phoenix.LiveView.Socket.t()) :: {:noreply, any}
  def handle_event("compute", %{"bday" => bday}, %{assigns: assigns} = socket) do
    case Calculator.from_params(assigns.calc, bday) do
      {:ok, calc} ->
        next_calc = Calculator.compute_weeks_and_days(calc)
        links = Links.get_links_for_week(next_calc.age_in_weeks)
        {:noreply, assign(socket, error: nil, links: links, calc: next_calc)}

      {:error, message} ->
        {:noreply, assign(socket, error: message)}
    end
  end

  def handle_event("up", value, %{assigns: assigns} = socket) do
    interval = String.to_existing_atom(value)
    calc = assigns.calc |> Calculator.handle_up(interval) |> Calculator.compute_weeks_and_days()
    links = Links.get_links_for_week(calc.age_in_weeks)

    {:noreply,
     assign(socket, error: nil, links: links, calc: Calculator.compute_weeks_and_days(calc))}
  end

  def handle_event("down", value, %{assigns: assigns} = socket) do
    interval = String.to_existing_atom(value)
    calc = assigns.calc |> Calculator.handle_down(interval) |> Calculator.compute_weeks_and_days()
    links = Links.get_links_for_week(calc.age_in_weeks)

    {:noreply,
     assign(socket, error: nil, links: links, calc: Calculator.compute_weeks_and_days(calc))}
  end
end
