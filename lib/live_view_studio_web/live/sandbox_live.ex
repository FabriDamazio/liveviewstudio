defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Build A Sandbox</h1>
    <div id="sandbox">
      <form>
        <div class="fields">
          <div>
            <label for="length">Length</label>
            <div class="input">
              <input type="number" name="length" value="1" />
              <span class="unit">feet</span>
            </div>
          </div>
          <div>
            <label for="width">Width</label>
            <div class="input">
              <input type="number" name="width" value="2" />
              <span class="unit">feet</span>
            </div>
          </div>
          <div>
            <label for="depth">Depth</label>
            <div class="input">
              <input type="number" name="depth" value="3" />
              <span class="unit">inches</span>
            </div>
          </div>
        </div>
        <div class="weight">
          You need 43 pounds of sand 🏝
        </div>
        <button type="submit">
          Get A Quote
        </button>
      </form>
      <div class="quote">
        Get your personal beach today for only $65
      </div>
    </div>
    """
  end
end
