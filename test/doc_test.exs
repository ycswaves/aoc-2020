defmodule DocTest do
  use ExUnit.Case, async: true
  doctest Report
  doctest Password
  doctest Trajectory
  doctest Passport
end
