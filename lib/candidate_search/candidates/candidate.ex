defmodule CandidateSearch.Candidates.Candidate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "candidates" do
    field :name, :string
    field :qualifications, {:array, :string}
    field :birth_date, :date
    field :total_experience, :integer

    timestamps()
  end

  def changeset(candidate, attrs \\ %{}) do
    candidate
    |> cast(attrs, [:name, :qualifications, :birth_date, :total_experience])
    |> validate_required([:name, :qualifications, :birth_date, :total_experience])
    |> validate_inclusion(:total_experience, 0..40)
  end
end
