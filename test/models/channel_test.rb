require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  test "identifier uniqueness" do
    channel = Channel.new
    channel.identifier = 'live'
    channel.guide_server = guide_servers(:one)
    assert channel.save == false
    
    channel.identifier = 'something-else-entirely'
    assert channel.save!
    
    channel.destroy
  end
end
