defmodule Events.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :invitee, :string
      add :response, :string
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:invites, [:event_id])
  end
end
