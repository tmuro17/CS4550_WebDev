defmodule EventsWeb.SessionController do
  use EventsWeb, :controller

  def create(conn, %{"email" => email}) do
    user = Events.Users.get_user_by_email(email)

    if user do
      page_back = get_session(conn, :page_back)
      if page_back != nil do
        conn
        |> put_session(:user_id, user.id)
        |> assign(:current_user, user)
        |> put_flash(:info, "Signed in as #{user.name}")
        |> delete_session(:page_back)
        |> redirect(to: page_back)
      else
        conn
        |> put_session(:user_id, user.id)
        |> assign(:current_user, user)
        |> put_flash(:info, "Signed in as #{user.name}")
        |> redirect(to: Routes.page_path(conn, :index))
      end
    else
      conn
      |> put_flash(:error, "Failed to login")
      |> redirect(to: Routes.page_path(conn, :index))
    end

  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
