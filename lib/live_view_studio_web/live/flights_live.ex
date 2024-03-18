defmodule LiveViewStudioWeb.FlightsLive do
  alias LiveViewStudio.Flights
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        airport: "",
        flights: [],
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Flight</h1>
    <div id="flights">
      <form phx-submit="search">
        <input
          type="text"
          name="airport"
          value={@airport}
          placeholder="Airport Code"
          autofocus
          autocomplete="off"
          readonly={@loading}
        />

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>

      <div :if={@loading} class="loader">Loading...</div>

      <div class="flights">
        <ul>
          <li :for={flight <- @flights}>
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
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("search", %{"airport" => airport}, socket) do
    send(self(), {:run_search, airport})

    socket =
      assign(socket,
        airport: airport,
        flights: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_search, airport}, socket) do
    flights = Flights.search_by_airport(airport)

    socket =
      assign(socket,
        flights: flights,
        loading: false
      )

    {:noreply, socket}
  end
end
