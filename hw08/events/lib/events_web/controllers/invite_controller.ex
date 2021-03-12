defmodule EventsWeb.InviteController do
  use EventsWeb, :controller

  alias Events.Invites
  alias Events.Invites.Invite

  def index(conn, _params) do
    #    user = conn.assigns[:current_user]

    #    details = if user != nil do
    #      is = Invites.list_invites_for_email(user.email)
    #
    #      ies = Enum.map(is, fn i -> {i, Events.CalEvents.get_event!(i.event_id)} end)
    #      ies
    #    else
    #      IO.puts("not registered")
    #      []
    #    end
    #
    #    render(conn, "index.html", details: details)

    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def new(conn, params) do
    event_id = params["event_id"]
    changeset = Invites.change_invite(%Invite{})
    render(conn, "new.html", changeset: changeset, event_id: event_id)
  end

  def create(conn, %{"invite" => invite_params}) do
    case Invites.create_invite(invite_params) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "Invite created successfully. Link: #{EventsWeb.Endpoint.url()}#{Routes.event_path(conn, :show, invite.event_id)}")
        |> redirect(to: Routes.event_path(conn, :show, invite.event_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    render(conn, "show.html", invite: invite)
  end

  def edit(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    changeset = Invites.change_invite(invite)
    render(conn, "edit.html", invite: invite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invite" => invite_params}) do
    invite = Invites.get_invite!(id)

    case Invites.update_invite(invite, invite_params) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "Invite updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, invite.event_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invite: invite, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    {:ok, _invite} = Invites.delete_invite(invite)

    conn
    |> put_flash(:info, "Invite deleted successfully.")
    |> redirect(to: Routes.invite_path(conn, :index))
  end
end
