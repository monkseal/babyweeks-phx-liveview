defmodule BabyweeksWeb.BabyweeksLiveView do
  require Logger
  use Phoenix.LiveView

  # def render(assigns) do
  #   ~L"""
  #   <div>
  #     <form>
  #       <table>
  #         <tbody>
  #           <tr>
  #             <th>Month</th>
  #             <th>Day</th>
  #             <th>Year</th>
  #           </tr>
  #           <tr>
  #             <td><input type="text" name="m" value="09" size="5"></td>
  #             <td><input type="text" name="d" value="22" size="5"></td>
  #             <td><input type="text" name="y" value="2018" size="5"></td>
  #           </tr>
  #         </tbody>
  #       </table>
  #       <button phx-click="compute">Compute</button>
  #       <h3><%= @weeks %> weeks, <%= @days %> days old</h3>
  #     </form>
  #   </div>
  #   """
  # end
  alias BabyweeksWeb.BabyweeksView
  def render(assigns) do
    BabyweeksView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    bday = %{"m" => "9", "d" => "22", "y" => "2018"}
    # bday = %{"m" => Timex.today.month, "d" => Timex.today.day, "y" => Timex.today.year}

    {:ok, assign(socket, weeks: 0, days: 0, bday: bday, error: nil  ) }
  end

  def handle_event("compute", %{"bday" => bday}, socket) do
    case Timex.parse("#{bday["y"]}-#{bday["m"]}-#{bday["d"]}", "{YYYY}-{M}-{D}") do
      {:ok, start_date} ->
        end_date = Timex.today
        date_diff = fn (diffing) -> Timex.diff(end_date, start_date, diffing) end
        {:noreply, assign(socket, weeks: date_diff.(:weeks), days:  (date_diff.(:days) - date_diff.(:weeks) * 7) , bday: bday, error: nil) }
      {:error, _} ->
        {:noreply, assign(socket, weeks: 0, days: 0, bday: bday, error: "Invalid date"  ) }
    end
  end
end
