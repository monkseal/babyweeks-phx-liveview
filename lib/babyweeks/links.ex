defmodule Babyweeks.Links do
  defstruct weeks: []

  defmodule Link do
    defstruct href: nil, title: nil
  end

  defmodule WeekLink do
    defstruct week_range: nil, links: []
  end

  defmodule LinkStore do
    @wonder_weeks_links [
      # Mental Leap 1 – Wonder Week 5
      # https://www.thewonderweeks.com/mental-leap-1/
      %{
        week: 5,
        link: "https://www.thewonderweeks.com/mental-leap-1"
      },

      # Mental Leap 2 – Wonder Week 8
      #
      %{
        week: 8,
        link: "https://www.thewonderweeks.com/mental-leap-2"
      },

      # Mental Leap 3 – Wonder Week 12
      # https://www.thewonderweeks.com/mental-leap-3/
      %{
        week: 12,
        link: "https://www.thewonderweeks.com/mental-leap-3"
      },

      # Mental Leap 4 – Wonder Week 19
      # https://www.thewonderweeks.com/mental-leap-4/
      %{
        week: 19,
        link: "https://www.thewonderweeks.com/mental-leap-4"
      },

      # Mental Leap 5 – Wonder Week 26
      # https://www.thewonderweeks.com/mental-leap-5/
      %{
        week: 26,
        link: "https://www.thewonderweeks.com/mental-leap-5"
      },

      # Mental Leap 6 – Wonder Week 37
      # https://www.thewonderweeks.com/mental-leap-6/
      %{
        week: 37,
        link: "https://www.thewonderweeks.com/mental-leap-6"
      },

      # Mental Leap 7 – Wonder Week 46
      # https://www.thewonderweeks.com/mental-leap-7/
      %{
        week: 46,
        link: "https://www.thewonderweeks.com/mental-leap-7"
      },

      # Mental Leap 8 – Wonder Week 55
      # https://www.thewonderweeks.com/mental-leap-8/
      %{
        week: 55,
        link: "https://www.thewonderweeks.com/mental-leap-8"
      },
      # Mental Leap 9 – Wonder Week 64
      # https://www.thewonderweeks.com/mental-leap-9/
      %{
        week: 65,
        link: "https://www.thewonderweeks.com/mental-leap-9"
      },
      # Mental Leap 10 – Wonder Week 75
      # https://www.thewonderweeks.com/mental-leap-10/
      %{
        week: 75,
        link: "https://www.thewonderweeks.com/mental-leap-10"
      }
    ]

    def get_wonder_weeks_links do
      @wonder_weeks_links
    end
  end

  alias Babyweeks.Links.LinkStore
  def get_links_for_week(week) when week < 1, do: []

  def get_links_for_week(week) do
    wonder_weeks = LinkStore.get_wonder_weeks_links()

    cond do
      week < List.first(wonder_weeks)[:week] ->
        main_week = List.first(wonder_weeks)
        [build_link(main_week, true)]

      week > List.last(wonder_weeks)[:week] ->
        main_week = List.last(wonder_weeks)
        [build_link(main_week)]

      true ->
        build_links_by_range(wonder_weeks, week)
    end
  end

  @spec build_links_by_range(any, any) :: [Babyweeks.Links.Link.t(), ...]
  defp build_links_by_range(wonder_weeks, week) do
    main_week_value..upcoming_week_value =
      Enum.find(wonder_week_ranges(wonder_weeks), fn r -> Enum.member?(r, week) end)

    main_week = Enum.find(wonder_weeks, fn w -> w[:week] == main_week_value end)
    upcoming_week = Enum.find(wonder_weeks, fn w -> w[:week] == upcoming_week_value + 1 end)

    [
      build_link(main_week, false),
      build_link(upcoming_week, true)
    ]
  end

  def build_link(week_link, upcoming \\ false) do
    %{"leap" => main_week_leep} =
      Regex.named_captures(~r/mental-leap-(?<leap>[\d|-]+)/, week_link[:link])

    %Babyweeks.Links.Link{
      href: week_link[:link],
      title:
        "#{if upcoming, do: "UPCOMING "}Mental Leap #{main_week_leep} – Wonder Week #{
          week_link[:week]
        }"
    }
  end

  defp wonder_week_ranges(wonder_weeks) do
    wonder_weeks
    |> Enum.with_index(0)
    |> Enum.map(fn {week, i} ->
      upcoming_week = Enum.at(wonder_weeks, i + 1, %{week: 9999})
      week[:week]..(upcoming_week[:week] - 1)
    end)
  end
end
