defmodule EventsWeb.PageController do
  use EventsWeb, :controller

  alias Events.CalEvents

  def index(conn, _params) do
    conn = put_session(conn, :page_back, Routes.page_path(conn, :index))

    user = conn.assigns[:current_user]

    {events, invites} = if user != nil do
      events = CalEvents.list_events()
               |> Enum.filter fn e -> CalEvents.is_owner?(e.id, user) end

      invites = Events.Invites.list_invites_for_email(user.email) |> Enum.map fn i -> {i, CalEvents.get_event!(i.event_id)} end
      {events, invites}
    else
      {[], []}
    end
    render(conn, "index.html", events: events, invites: invites)
  end
end
