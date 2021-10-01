defmodule PetalsDragNDropWeb.PageLive do
  use PetalsDragNDropWeb, :live_view
  alias PetalsDragNDropWeb.Components.GridWithDragAndDrop

  data world, :string, default: "world!"

  data width, :integer, default: 6
  data height, :integer, default: 6
  data data, :list, default: []
  data tick_interval, :integer, default: 1000

  @impl true
  def render(assigns) do
    ~F"""
      <div
        id="page"
        :hook="Page"
        x-data
        x-init="setTimeout(() => { pageHook.pushEvent('set_world', 'WORLD!') }, 1000)"
        class="h-screen flex flex-col gap-10 justify-center items-center font-bold text-3xl bg-gray-100"
      >
        <div class="mb-10">Hello {@world}</div>

        <GridWithDragAndDrop
          id="grid"
          dragged="letter_dragged"
          data={@data}
          width={@width}
          height={@height}
        >
          <:default :let={item: item}>
            <div class="flex justify-center items-center bg-white rounded-lg shadow w-10 h-10 font-mono">
              {item.text}
            </div>
          </:default>

          <:empty>
            <div class="flex justify-center items-center w-10 h-10 font-mono">
              .
            </div>
          </:empty>
        </GridWithDragAndDrop>
      </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    assigns = socket.assigns
    if connected?(socket), do: Process.send_after(self(), :tick, assigns.tick_interval)

    {:ok, assign(socket, data: generate_grid_data(assigns.width, assigns.height))}
  end

  @impl true
  def handle_event("set_world", value, socket) do
    {:noreply, assign(socket, world: value)}
  end

  @impl true
  def handle_event("letter_dragged", %{"from" => from, "to" => to}, socket) do
    to = parse_coordinates(to)
    {:noreply, update(socket, :data, fn data -> move(data, from["id"], to) end)}
  end

  @impl true
  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, socket.assigns.tick_interval)
    {:noreply, assign(socket, data: shift_grid_data(socket.assigns))}
  end

  defp parse_coordinates(%{"x" => x, "y" => y}),
    do: %{x: String.to_integer(x), y: String.to_integer(y)}

  defp move(data, from_id, to) do
    old = Enum.find(data, fn i -> i.id == from_id end)
    new = %{old | x: to.x, y: to.y}
    without_old = Enum.reject(data, fn i -> i == old end)
    [new | without_old]
  end

  defp generate_grid_data(w, h, offset \\ 0, text \\ "Hello world!") do
    get_x = fn i -> rem(i, w) + 1 end
    get_y = fn i -> rem(div(i, w) + 1, h) end

    text
    |> String.graphemes()
    |> Enum.with_index(offset)
    |> Enum.map(fn {c, i} -> %{text: c, id: "#{i}", x: get_x.(i), y: get_y.(i)} end)
  end

  defp shift_grid_data(%{width: w, height: h, data: data}) do
    get_x = fn x -> rem(x, w) + 1 end
    get_y = fn {x, y} -> rem(y + div(x, w) - 1, h) + 1 end

    data
    |> Enum.map(fn %{x: x, y: y} = entry -> %{entry | x: get_x.(x), y: get_y.({x, y})} end)
  end
end
