defmodule EventsWeb.PageController do
  use EventsWeb, :controller

  alias Events.CalEvents

  def index(conn, _params) do
    events = CalEvents.list_events()
    render(conn, "index.html", events: events)
  end
end
