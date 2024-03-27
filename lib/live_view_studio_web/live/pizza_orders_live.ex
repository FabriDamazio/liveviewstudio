defmodule LiveViewStudioWeb.PizzaOrdersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.PizzaOrders
  import Number.Currency

  def mount(_params, _session, socket) do
    {:ok, assign(socket, temporary_assigns: [pizza_orders: []])}
  end

  def handle_params(params, _uri, socket) do
    sort_by = valid_sort_by(params)
    sort_order = valid_sort_order(params)
    page = valid_page(params)
    per_page = valid_per_page(params)

    options = %{sort_by: sort_by, sort_order: sort_order, page: page, per_page: per_page}

    {:noreply,
     assign(socket,
       pizza_orders: PizzaOrders.list_pizza_orders(options),
       options: options
     )}
  end

  def handle_event("pagination", %{"selected" => selected}, socket) do
    options = socket.assigns.options
    selected = String.to_integer(selected)
    IO.inspect(selected)
    socket = assign(socket, per_page: selected)

    IO.inspect(socket)

    {:noreply,
     redirect(socket,
       to:
         ~p"/pizza-orders?#{%{per_page: selected, page: options.page, sort_by: options.sort_by, sort_order: options.sort_order}}"
     )}
  end

  attr :sort_by, :atom, required: true
  attr :options, :map, required: true
  slot :inner_block, required: true

  def sort_link(assigns) do
    ~H"""
    <.link patch={
      ~p"/pizza-orders?#{%{sort_by: @sort_by, sort_order: next_sort_order(@options.sort_order)}}"
    }>
      <%= render_slot(@inner_block) %>
      <%= sort_indicator(@sort_by, @options) %>
    </.link>
    """
  end

  defp next_sort_order(:asc), do: :desc
  defp next_sort_order(:desc), do: :asc

  defp sort_indicator(column, %{sort_by: sort_by, sort_order: sort_order})
       when column == sort_by do
    case sort_order do
      :asc -> "👆"
      :desc -> "👇"
    end
  end

  defp sort_indicator(_, _), do: ""

  defp valid_sort_by(%{"sort_by" => sort_by})
       when sort_by in ~w(size style topping_1 topping_2 price) do
    String.to_atom(sort_by)
  end

  defp valid_sort_by(_params), do: :id

  defp valid_sort_order(%{"sort_order" => sort_order}) when sort_order in ~w(asc desc) do
    String.to_atom(sort_order)
  end

  defp valid_sort_order(_params), do: :asc

  def valid_page(%{"page" => page}) do
    case page |> Integer.parse() do
      {page, _} when page > 0 ->
        page

      :error ->
        1

      _ ->
        1
    end
  end

  def valid_page(_params), do: 1

  def valid_per_page(%{"per_page" => per_page}) do
    case per_page |> Integer.parse() do
      {per_page, _} when per_page > 0 ->
        per_page

      :error ->
        5

      _ ->
        5
    end
  end

  def valid_per_page(_params), do: 1
end
