defmodule PetalsDragNDropWeb.LayoutView do
  use PetalsDragNDropWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def render("root.html", assigns) do
    ~F"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        {csrf_meta_tag()}
        {live_title_tag assigns[:page_title] || "PetalsDragNDrop", suffix: " · Phoenix Framework"}
        <link phx-track-static rel="stylesheet" href={Routes.static_path(@conn, "/assets/app.css")}/>
        <script defer phx-track-static type="text/javascript" src={Routes.static_path(@conn, "/assets/app.js")}></script>
      </head>
      <body>
        {@inner_content}
      </body>
    </html>
    """
  end
end
