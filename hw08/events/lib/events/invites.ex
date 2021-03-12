defmodule Events.Invites do
  @moduledoc """
  The Invites context.
  """

  import Ecto.Query, warn: false
  alias Events.Repo

  alias Events.Invites.Invite

  @doc """
  Returns the list of invites.

  ## Examples

      iex> list_invites()
      [%Invite{}, ...]

  """
  def list_invites do
    Repo.all(Invite)
  end

  @doc """
  Gets a single invite.

  Raises `Ecto.NoResultsError` if the Invite does not exist.

  ## Examples

      iex> get_invite!(123)
      %Invite{}

      iex> get_invite!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invite!(id), do: Repo.get!(Invite, id)

  @doc """
  Creates a invite.

  ## Examples

      iex> create_invite(%{field: value})
      {:ok, %Invite{}}

      iex> create_invite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invite(attrs \\ %{}) do
    %Invite{}
    |> Invite.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a invite.

  ## Examples

      iex> update_invite(invite, %{field: new_value})
      {:ok, %Invite{}}

      iex> update_invite(invite, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invite(%Invite{} = invite, attrs) do
    invite
    |> Invite.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a invite.

  ## Examples

      iex> delete_invite(invite)
      {:ok, %Invite{}}

      iex> delete_invite(invite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invite(%Invite{} = invite) do
    Repo.delete(invite)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invite changes.

  ## Examples

      iex> change_invite(invite)
      %Ecto.Changeset{data: %Invite{}}

  """
  def change_invite(%Invite{} = invite, attrs \\ %{}) do
    Invite.changeset(invite, attrs)
  end

  def num_yes_responses(event_id) do
    query = from i in Invite,
                 where: i.event_id == ^event_id and i.response == "Yes",
                 select: count(i)


    Repo.all(query)
  end

  def num_maybe_responses(event_id) do
    query = from i in Invite,
                 where: i.event_id == ^event_id and i.response == "Maybe",
                 select: count(i)


    Repo.all(query)

  end

  def num_no_responses(event_id) do
    query = from i in Invite,
                 where: i.event_id == ^event_id and i.response == "No",
                 select: count(i)


    Repo.all(query)

  end

  def num_havent_responses(event_id) do
    query = from i in Invite,
                 where: i.event_id == ^event_id and i.response == "Haven't Responded",
                 select: count(i)


    Repo.all(query)

  end

  def list_invites_for_event(event_id) do
    query = from i in Invite,
                 where: i.event_id == ^event_id

    Repo.all(query)
  end

  def list_invites_for_email(email) do
    query = from i in Invite,
                 where: i.invitee == ^email

    Repo.all(query)
  end

  def get_invite_for_event_and_email(event_id, email) do
    query = from i in Invite,
                 where: i.invitee == ^email and i.event_id == ^event_id

    results = Repo.all(query)

    if Enum.empty?(results) do
      nil
    else
      hd results
    end
  end
end
