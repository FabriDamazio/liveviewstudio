defmodule LiveViewStudioWeb.CustomComponents do
  use Phoenix.Component

  attr :expiration, :integer, default: 24
  slot :legal
  slot :inner_block, required: true

  def promo(assigns) do
    ~H"""
    <div class="promo">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>
      <div class="expiration">
        Deal expires in assigns.expiration hours
      </div>
      <div class="legal">
        <%= render_slot(@legal) %>
      </div>
    </div>
    """
  end

  attr :visible, :boolean, default: false

  def loading_indicator(assigns) do
    ~H"""
    <div :if={@visible} class="loader">Loading...</div>
    """
  end
end
