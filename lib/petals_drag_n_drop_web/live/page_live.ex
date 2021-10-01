defmodule PetalsDragNDropWeb.PageLive do
  use PetalsDragNDropWeb, :live_view

  data world, :string, default: "world!"

  @impl true
  def render(assigns) do
    ~F"""
      <div>Hello {@world}</div>
    """
  end
end
