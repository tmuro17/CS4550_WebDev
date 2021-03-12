defmodule EventsWeb.EventController do
  use EventsWeb, :controller

  alias Events.CalEvents
  alias Events.CalEvents.Event
  alias Events.Invites
  alias Events.Comments
  alias Events.Users

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    events = if user == nil do
      []
    else
      CalEvents.list_events()
      |> Enum.filter(fn e -> CalEvents.is_owner?(e.id, user) end)
    end
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = CalEvents.change_event(%Event{})
    user = conn.assigns[:current_user]
    render(conn, "new.html", changeset: changeset, user_id: user.id)
  end

  def create(conn, %{"event" => event_params}) do
    case CalEvents.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = CalEvents.get_event!(id)
    invites = Invites.list_invites_for_event(id)

    user = conn.assigns[:current_user]

    if user == nil do
      back = Routes.event_path(conn, :show, event.id)
      conn = assign(conn, :page_back, back)
      conn = put_session(conn, :page_back, back)
      render(conn, "show.html")
    else

      if Events.CalEvents.is_invitee?(id, user) or Events.CalEvents.is_owner?(id, user) do
        yes = Invites.num_yes_responses(id)
              |> hd
        maybe = Invites.num_maybe_responses(id)
                |> hd
        no = Invites.num_no_responses(id)
             |> hd
        havent = Invites.num_havent_responses(id)
                 |> hd

        invite_id = if Events.CalEvents.is_invitee?(id, user) do
          Events.Invites.get_invite_for_event_and_email(id, user.email)
        else
          nil
        end

        comments = Comments.list_comments_for_event(id)
        comment_details = Enum.map(comments, fn c -> {c, Users.get_user!(c.user_id)} end)

        render(
          conn,
          "show.html",
          event: event,
          comment_details: comment_details,
          invites: invites,
          num_yes: yes,
          num_no: no,
          num_maybe: maybe,
          num_havent: havent,
          invite_id: invite_id
        )
      else
        redirect(conn, to: Routes.page_path(conn, :index))
      end
    end
  end

  def edit(conn, %{"id" => id}) do
    event = CalEvents.get_event!(id)
    changeset = CalEvents.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = CalEvents.get_event!(id)

    case CalEvents.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = CalEvents.get_event!(id)
    {:ok, _event} = CalEvents.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
