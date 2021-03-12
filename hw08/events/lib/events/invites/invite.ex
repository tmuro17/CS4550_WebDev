defmodule Events.Invites.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invites" do
    field :invitee, :string
    field :response, :string, default: "Haven't Responded"
    field :event_id, :id

    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:invitee, :response, :event_id])
    |> validate_required([:invitee, :event_id])
  end
end
