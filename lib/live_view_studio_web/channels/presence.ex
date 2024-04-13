defmodule LiveViewStudioWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :live_view_studio,
    pubsub_server: LiveViewStudio.PubSub

  def list_users(topic) do
    list(topic) |> simplify_presences()
  end

  def update_presences(presences, leaves, joins) do
    user_ids = Enum.map(leaves, fn {user_id, _} -> user_id end)

    Map.drop(presences, user_ids)
    |> Map.merge(simplify_presences(joins))
  end

  defp simplify_presences(presences) do
    Enum.into(presences, %{}, fn {user_id, %{metas: [meta | _]}} ->
      {user_id, meta}
    end)
  end
end
