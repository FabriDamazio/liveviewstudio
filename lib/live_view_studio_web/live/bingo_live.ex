defmodule LiveViewStudioWeb.BingoLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudioWeb.Presence

  @topic "users:bingo"

  on_mount {LiveViewStudioWeb.UserAuth, :ensure_authenticated}

  def mount(_params, _session, socket) do
    %{current_user: current_user} = socket.assigns

    if connected?(socket) do
      :timer.send_interval(3000, self(), :pick)

      Phoenix.PubSub.subscribe(LiveViewStudio.PubSub, @topic)

      {:ok, _} =
        Presence.track(self(), @topic, current_user.id, %{
          username: current_user.email |> String.split("@") |> hd(),
          time: Timex.now() |> Timex.format!("%H:%M", :strftime)
        })
    end

    socket =
      assign(socket,
        number: nil,
        numbers: all_numbers(),
        presences: Presence.list_users(@topic)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Bingo Boss 📢</h1>
    <div id="bingo">
      <div class="users">
        <ul>
          <li :for={{_user_id, presence} <- @presences}>
            <span class="username">
              <%= presence.username %>
            </span>
            <span class="timestamp">
              <%= presence.time %>
            </span>
          </li>
        </ul>
      </div>
      <div id="bingo">
        <div class="number">
          <%= @number %>
        </div>
      </div>
    </div>
    """
  end

  # Assigns the next random bingo number, removing it
  # from the assigned list of numbers. Resets the list
  # when the last number has been picked.
  def pick(socket) do
    case socket.assigns.numbers do
      [head | []] ->
        assign(socket, number: head, numbers: all_numbers())

      [head | tail] ->
        assign(socket, number: head, numbers: tail)
    end
  end

  # Returns a list of all valid bingo numbers in random order.
  #
  # Example: ["B 4", "N 40", "O 73", "I 29", ...]
  def all_numbers() do
    ~w(B I N G O)
    |> Enum.zip(Enum.chunk_every(1..75, 15))
    |> Enum.flat_map(fn {letter, numbers} ->
      Enum.map(numbers, &"#{letter} #{&1}")
    end)
    |> Enum.shuffle()
  end

  def handle_info(:pick, socket) do
    {:noreply, pick(socket)}
  end

  def handle_info(%{event: "presence_diff", payload: diff}, socket) do
    socket =
      assign(
        socket,
        :presences,
        Presence.update_presences(socket.assigns.presences, diff.leaves, diff.joins)
      )

    {:noreply, socket}
  end
end
