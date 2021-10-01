defmodule PetalsDragNDrop.Repo do
  use Ecto.Repo,
    otp_app: :petals_drag_n_drop,
    adapter: Ecto.Adapters.Postgres
end
