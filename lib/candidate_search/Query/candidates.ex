defmodule CandidateSearch.Query.Candidates do
  @moduledoc """
  Module used to query candidates from the Repo
  """
  alias CandidateSearch.Repo
  alias CandidateSearch.Candidates.Candidate
  import Ecto.Query

  def get_all_candidates() do
    Candidate
    |> Repo.all()
    |> Enum.map(&(Map.from_struct(&1) |> Map.drop([:__meta__])))
  end

  def create_candidate(attrs \\ %{}) do
    %Candidate{}
    |> Candidate.changeset(attrs)
    |> Repo.insert()
  end

  def update_candidate(id, candidate_data) do
    case Candidate |> Repo.get(id) do
      nil ->
        {:error, %{"status" => "fail", "message" => "Candidate not found."}}

      data ->
        changeset = Candidate.changeset(data, candidate_data)

        case changeset.valid? do
          false ->
            error_result =
              Enum.reduce(changeset.errors, [], fn {key, val}, acc ->
                [Map.put(%{}, key, elem(val, 0)) | acc]
              end)

            {:error, %{"status" => "fail", "errors" => error_result}}

          true ->
            Repo.update(changeset)
            {:success, %{"status" => "ok", "message" => "Candidate update successful."}}
        end
    end
  end

  def delete_candidate(id) do
    case Candidate |> Repo.get(id) do
      nil ->
        {:error, %{"status" => "fail", "message" => "Candidate not found."}}

      data ->
        Repo.delete(data) |> IO.inspect()
        {:success, %{"status" => "ok", "message" => "Candidate deletion successful."}}
    end
  end

  @doc """
  return changest with errors to be used by the create form
  """
  def change_candidate(%Candidate{} = candidate, attrs \\ %{}) do
    candidate
    |> Candidate.changeset(attrs)
  end

  def get_by_filter(filter) do
    Candidate
    |> filter_by_qualifications(filter["qualifications"])
    |> filter_by_experience(filter["total_experience"])
    |> filter_by_age(filter["age"])
    |> Repo.all()
    |> Enum.map(&(Map.from_struct(&1) |> Map.drop([:__meta__])))
  end

  def filter_by_experience(query, value)
      when value === nil or value === "" or value === "undefined" do
    query
  end

  def filter_by_experience(query, exp) do
    exp = String.to_integer(exp)
    where(query, [c], c.total_experience == ^exp)
  end

  def filter_by_qualifications(query, value)
      when value === nil or value === "" or value === "undefined" or value === [""] do
    query
  end

  def filter_by_qualifications(query, q) when is_binary(q) do
    _raw_postgres_query = "SELECT * FROM candidates as c WHERE c.qualifications @> '{SSC}';"
    filtered_q = Enum.filter(String.split(q, ","), fn x -> x != "" end)
    where(query, [c], fragment("? @> ?", c.qualifications, ^filtered_q))
  end

  def filter_by_qualifications(query, q) do
    _raw_postgres_query = "SELECT * FROM candidates as c WHERE c.qualifications @> '{SSC}';"
    filtered_q = Enum.filter(q, fn x -> x != "" end)
    where(query, [c], fragment("? @> ?", c.qualifications, ^filtered_q))
  end

  def filter_by_age(query, value) when value === nil or value === "" or value === "undefined" do
    query
  end

  # throws error due to invalid conversion // expects interval
  @doc """
  returns the result from database filtered by `age`

  IMPORTANT NOTE: input `age` must be parsed to Float for the query to be processed by the Postgresql

  EXPECT ERROR: "** (DBConnection.EncodeError) Postgrex expected a float, got "1"."
  """
  def filter_by_age(query, age) do
    _raw_postgres_query =
      "SELECT * as age FROM candidates WHERE DATE_PART('year', AGE(birth_date)) < 30;"

    date_part = "year"
    age = String.to_float(age <> ".0")

    where(
      query,
      [c],
      fragment("DATE_PART(?, AGE(?)) < ?::float", ^date_part, c.birth_date, ^age)
    )
  end
end
