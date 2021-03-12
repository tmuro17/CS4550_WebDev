defmodule EventsWeb.CommentController do
  use EventsWeb, :controller

  alias Events.Comments
  alias Events.Comments.Comment

  def index(conn, _params) do
    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def new(conn, params) do
    if conn.assigns[:current_user] == nil do
      conn
      |> put_flash(:error, "Log in or register")
      |> redirect(to: Routes.page_path(conn, :index))
    end
    event_id = params["event_id"]
    changeset = Comments.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset, event_id: event_id)
  end

  def create(conn, %{"comment" => comment_params}) do
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, comment.event_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    changeset = Comments.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, comment.event_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :show, comment.event_id))
  end
end
