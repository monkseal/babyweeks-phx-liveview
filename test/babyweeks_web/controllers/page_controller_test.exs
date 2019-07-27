defmodule BabyweeksWeb.PageControllerTest do
  use BabyweeksWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Baby Age Calendar"
  end
end
