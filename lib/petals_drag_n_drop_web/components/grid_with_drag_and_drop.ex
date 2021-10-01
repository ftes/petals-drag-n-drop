defmodule PetalsDragNDropWeb.Components.GridWithDragAndDrop do
  use PetalsDragNDropWeb, :component

  prop id, :string, required: true
  prop data, :list, required: true
  prop width, :integer
  prop height, :integer
  prop dragged, :event
  slot default, args: [item: ^data], required: true
  slot empty

  @impl true
  def render(assigns) do
    ~F"""
    <div
      x-data="{dragging: false}"
      class="grid gap-2 auto-cols-fr"
      id={@id}
      :hook="GridWithDragAndDrop"
    >
      {#for %{x: x, y: y} = item <- @data}
        <div
          id={item[:id]}
          style={'grid-column': x, 'grid-row': y}
          draggable="true"
          class="flex flex-grow cursor-move border-4 border-opacity-0"
          x-on:dragstart.self="
            dragging = true;
            event.dataTransfer.effectAllowed = 'move';
            event.dataTransfer.setData('text/plain', event.target.id);
          "
          x-on:dragend.self="dragging = false"
        >
          <#slot :args={item: item} />
        </div>
      {/for}

      {#for {x, y} <- drop_targets(@data, @width, @height)}
        <div
          class="flex border-4 border-opacity-0"
          style={'grid-column': x, 'grid-row': y}
          data-x={x}
          data-y={y}
          x-on:drop.self={"
            dragging = false;
            const from = {id: document.getElementById(event.dataTransfer.getData('text/plain')).id};
            const to = event.target.dataset;
            const hook = window.phxHooks.GridWithDragAndDrop[$root.id];
            #{if @dragged.target == :live_view do
              "hook.pushEvent('#{@dragged.name}', {from, to});"
            else
              "hook.pushEventTo('#{@dragged.target}', '#{@dragged.name}', {from, to});"
            end}
          "}
          x-on:dragover.self="dragging = $el"
          x-on:dragleave.self="dragging = true"
          :class="{
            'border-opacity-100 border-dashed border-gray-200': dragging,
            'border-gray-500': dragging == $el,
          }"
        >
          <div class="flex flex-grow" :class="{invisible: dragging}">
            <#slot name="empty" />
          </div>
        </div>
      {/for}
    </div>
    """
  end

  defp drop_targets(data, width, height) do
    used = MapSet.new(data, &{&1.x, &1.y})
    all = MapSet.new(for x <- 1..width, y <- 1..height, do: {x, y})
    MapSet.difference(all, used)
  end
end
