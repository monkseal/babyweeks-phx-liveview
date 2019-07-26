defmodule Babyweeks.Repo do
  use Ecto.Repo,
    otp_app: :babyweeks,
    adapter: Ecto.Adapters.Postgres
end
