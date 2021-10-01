defmodule PetalsDragNDropWeb.PageLive do
  use PetalsDragNDropWeb, :live_view

  data world, :string, default: "world!"

  @impl true
  def render(assigns) do
    ~F"""
      <div
        id="page"
        :hook="Page"
        x-data
        x-init="setTimeout(() => { pageHook.pushEvent('set_world', 'WORLD!') }, 1000)"
        class="h-screen flex justify-center items-center font-bold text-3xl"
      >
        Hello {@world}
      </div>
    """
  end

  @impl true
  def handle_event("set_world", value, socket) do
    {:noreply, assign(socket, world: value)}
  end
end
