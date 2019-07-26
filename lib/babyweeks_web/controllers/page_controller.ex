defmodule BabyweeksWeb.PageController do
  use BabyweeksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
