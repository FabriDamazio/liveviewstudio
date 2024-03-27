defmodule LiveViewStudioWeb.BoatsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        filter: %{type: "", prices: []},
        boats: Boats.list_boats()
      )

    # temporary_assigns to avoid the boats assign to be persisted on the socket
    {:ok, socket, temporary_assigns: [boats: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>
    <.promo expiration={2}>
      Save 25% on rentals!
      <:legal>
        <Heroicons.exclamation_circle /> Limit 1 per party.
      </:legal>
    </.promo>
    <div id="boats">
      <.filter_form filter={@filter} />
      <.boats_list boats={@boats} />
      <.promo expiration={1}>
        Hurry! Only 3 boats left!
        <:legal>
          <Heroicons.exclamation_circle /> Excluding weekends.
        </:legal>
      </.promo>
    </div>
    """
  end

  attr :filter, :map, required: true

  def filter_form(assigns) do
    ~H"""
    <form phx-change="filter">
      <div class="filters">
        <select name="type">
          <%= Phoenix.HTML.Form.options_for_select(
            type_options(),
            @filter.type
          ) %>
        </select>
        <div class="prices">
          <%= for price <- ["$", "$$", "$$$"] do %>
            <input
              type="checkbox"
              name="prices[]"
              value={price}
              id={price}
              checked={price in @filter.prices}
            />
            <label for={price}><%= price %></label>
          <% end %>
          <input type="hidden" name="prices[]" value="" />
        </div>
      </div>
    </form>
    """
  end

  def boats_list(assigns) do
    ~H"""
    <div class="boats">
      <div :for={boat <- @boats} class="boat">
        <img src={boat.image} />
        <div class="content">
          <div class="model">
            <%= boat.model %>
          </div>
          <div class="details">
            <span class="price">
              <%= boat.price %>
            </span>
            <span class="type">
              <%= boat.type %>
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    boats = Boats.list_boats(%{type: type, prices: prices})

    # Just to show de difference between the assigned and filtered boats
    # when using temporary_assigns on mount. To see the difference, remove
    # the temporary_assigns from the mount
    IO.inspect(length(socket.assigns.boats), label: "Assigned boats")
    IO.inspect(length(boats), label: "Filtered boats")

    {:noreply, assign(socket, boats: boats, filter: %{type: type, prices: prices})}
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end
