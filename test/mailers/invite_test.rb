require 'test_helper'

class InviteTest < ActionMailer::TestCase
  test "send_invite" do
    mail = Invite.send_invite
    assert_equal "Send invite", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
