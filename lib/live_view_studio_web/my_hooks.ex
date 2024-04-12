defmodule LiveViewStudioWeb.MyHooks do
  use LiveViewStudioWeb, :verified_routes

  def on_mount(:current_time, _params, _session, socket) do
    {:cont, Phoenix.Component.assign(socket, :current_time, DateTime.utc_now())}
  end
end
