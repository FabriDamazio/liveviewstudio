defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10, temperature: "3000")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background: #{temp_color(@temperature)}"}>
          <%= @brightness %>%
        </span>
      </div>
      <button phx-click="off">
        <img src="/images/light-off.svg" />
      </button>
      <button phx-click="on">
        <img src="/images/light-on.svg" />
      </button>
      <button phx-click="down">
        <img src="/images/down.svg" />
      </button>
      <button phx-click="up">
        <img src="/images/up.svg" />
      </button>
      <button phx-click="random">
        <img src="/images/fire.svg" />
      </button>
    </div>

    <form phx-change="update">
      <input
        type="range"
        min="0"
        max="100"
        name="brightness"
        value={@brightness}
      />
    </form>

    <form phx-change="update-temp">
      <div class="temps">
        <%= for temp <- ["3000", "4000", "5000"] do %>
          <div>
            <input
              type="radio"
              id={temp}
              name="temp"
              value={temp}
              checked={temp == @temperature}
            />
            <label for={temp}><%= temp %></label>
          </div>
        <% end %>
      </div>
    </form>
    """
  end

  def handle_event("random", _, socket) do
    socket = assign(socket, brightness: Enum.random(0..100))
    {:noreply, socket}
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, brightness: 100)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(100, &1 + 10))
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(0, &1 - 10))
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end

  def handle_event("update", params, socket) do
    socket = assign(socket, brightness: String.to_integer(params["brightness"]))
    {:noreply, socket}
  end

  def handle_event("update-temp", params, socket) do
    socket = assign(socket, temperature: params["temp"])
    {:noreply, socket}
  end

  defp temp_color("3000"), do: "#F1C40D"
  defp temp_color("4000"), do: "#FEFF66"
  defp temp_color("5000"), do: "#99CCFF"
end
