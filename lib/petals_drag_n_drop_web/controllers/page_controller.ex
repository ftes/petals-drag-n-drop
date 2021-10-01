defmodule PetalsDragNDropWeb.PageController do
  use PetalsDragNDropWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
