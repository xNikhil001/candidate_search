defmodule CandidateSearch.Helper do
  def parse_to_integer(value) when is_binary(value) do
    case Integer.parse(value) do
      {num, _} -> parse_to_integer(num)
      :error -> 0
    end
  end

  def parse_to_integer(value) when is_integer(value) and value > 0, do: value

  def parse_to_integer(_), do: 0
end
