defmodule Babyweeks.LinksTest do
  use BabyweeksWeb.ConnCase
  alias Babyweeks.Links
  use ExUnit.Case

  describe "get_links_for_week" do
    test "for wonder week 5" do
      links = Links.get_links_for_week(5)
      [first_link | other_links] = links
      assert first_link.href == "https://www.thewonderweeks.com/mental-leap-1"
      assert first_link.title == "Mental Leap 1 – Wonder Week 5"
      [next_link | _] = other_links

      assert next_link.href == "https://www.thewonderweeks.com/mental-leap-2"
      assert next_link.title == "UPCOMING Mental Leap 2 – Wonder Week 8"
    end

    test "for week 7" do
      links = Links.get_links_for_week(7)
      [first_link | other_links] = links
      assert first_link.title == "Mental Leap 1 – Wonder Week 5"
      assert first_link.href == "https://www.thewonderweeks.com/mental-leap-1"
      [next_link | _] = other_links

      assert next_link.href == "https://www.thewonderweeks.com/mental-leap-2"
      assert next_link.title == "UPCOMING Mental Leap 2 – Wonder Week 8"
    end

    test "for week 8" do
      links = Links.get_links_for_week(8)
      [first_link | other_links] = links
      assert first_link.href == "https://www.thewonderweeks.com/mental-leap-2"
      assert first_link.title == "Mental Leap 2 – Wonder Week 8"
      [next_link | _] = other_links

      assert next_link.href == "https://www.thewonderweeks.com/mental-leap-3"
      assert next_link.title == "UPCOMING Mental Leap 3 – Wonder Week 12"
    end

    test "for week 2" do
      links = Links.get_links_for_week(2)
      [first_link | _tail] = links
      assert first_link.href == "https://www.thewonderweeks.com/mental-leap-1"
      assert first_link.title == "UPCOMING Mental Leap 1 – Wonder Week 5"
    end

    test "for undefined week" do
      links = Links.get_links_for_week(255)
      [first_link | _] = links
      assert first_link.href == "https://www.thewonderweeks.com/mental-leap-10"
      # assert first_link.href == "https://www.thewonderweeks.com/mental-leap-1"
      assert first_link.title == "Mental Leap 10 – Wonder Week 75"
    end

    test "for negative week value" do
      links = Links.get_links_for_week(-5)
      assert links == []
    end
  end
end
