defmodule Hub.MessagesTest do
  use Hub.ModelCase

  alias Hub.Messages

  @valid_attrs %{body: "some body", user_name: "some user_name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Messages.changeset(%Messages{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Messages.changeset(%Messages{}, @invalid_attrs)
    refute changeset.valid?
  end
end
