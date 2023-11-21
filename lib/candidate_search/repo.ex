defmodule CandidateSearch.Repo do
  use Ecto.Repo,
    otp_app: :candidate_search,
    adapter: Ecto.Adapters.Postgres
end
