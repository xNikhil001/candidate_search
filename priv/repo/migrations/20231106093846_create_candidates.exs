defmodule CandidateSearch.Repo.Migrations.CreateCandidates do
  use Ecto.Migration

  def change do
    create table(:candidates) do
      add :name, :string
      add :qualifications, {:array, :string}
      add :birth_date, :date
      add :total_experience, :integer

      timestamps()
    end
  end
end
