defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        airport: "",
        flights: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Flight</h1>
    <div id="flights">
      <form>
        <input
          type="text"
          name="airport"
          value={@airport}
          placeholder="Airport Code"
          autofocus
          autocomplete="off"
        />

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>

      <div class="flights">
        <ul>
          <%= for flight <- @flights do %>
            <li>
              <div class="first-line">
                <div class="number">
                  Flight #<%= flight.number %>
                </div>
                <div class="origin-destination">
                  <%= flight.origin %> to <%= flight.destination %>
                </div>
              </div>
              <div class="second-line">
                <div class="departs">
                  Departs: <%= flight.departure_time %>
                </div>
                <div class="arrives">
                  Arrives: <%= flight.arrival_time %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
