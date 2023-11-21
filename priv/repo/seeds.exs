# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CandidateSearch.Repo.insert!(%CandidateSearch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias CandidateSearch.Repo
alias CandidateSearch.Candidates.Candidate

Repo.insert!(%Candidate{
  name: "Nikhil Naik",
  qualifications: ["SSC", "HSSC", "DIPLOMA"],
  birth_date: ~D[2000-03-13],
  total_experience: 1
})

Repo.insert!(%Candidate{
  name: "John Doe",
  qualifications: ["SSC", "HSSC", "BE"],
  birth_date: ~D[1999-06-23],
  total_experience: 3
})

Repo.insert!(%Candidate{
  name: "Clark Kent",
  qualifications: ["SSC", "HSSC", "BCA"],
  birth_date: ~D[1995-01-01],
  total_experience: 5
})

Repo.insert!(%Candidate{
  name: "Lois Lane",
  qualifications: ["SSC", "BBA"],
  birth_date: ~D[2002-12-29],
  total_experience: 2
})

Repo.insert!(%Candidate{
  name: "Allen D",
  qualifications: ["DIPLOMA"],
  birth_date: ~D[1998-06-14],
  total_experience: 0
})
