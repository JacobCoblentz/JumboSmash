require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "friends can be made" do
    arya = User.find_by_name "Arya Stark"
    erik = User.find_by_name "Erik Formella"

    pp arya.add_request erik.id, SECRET
    pp erik.add_request arya.id, SECRET
    pp erik.resolve_queued_connections SECRET
    arya.reload
    pp arya.resolve_queued_connections SECRET

    pp arya.get_connections SECRET
    assert arya.get_connections(SECRET)[0] == erik, "friend was not made"
  end
end
