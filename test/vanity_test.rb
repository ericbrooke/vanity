require "test_helper"

describe Vanity do
  # describe "reconnect!" do
  #   it "reconnects with the same configuration" do
  #     Vanity.playground.establish_connection "mock:/"
  #     Vanity.playground.reconnect!
  #     assert_equal Vanity.playground.connection.to_s, "mock:/"
  #   end
  # end

  # describe "autoconnect" do
  #   it "establishes connection by default with connection" do
  #     instance = Vanity::Playground.new(:connection=>"mock:/")
  #     assert instance.connected?
  #   end

  #   it "establishes connection by default" do
  #     Vanity::Playground.any_instance.expects(:establish_connection)
  #     Vanity::Playground.new
  #   end

  #   it "can skip connection" do
  #     Vanity::Autoconnect.stubs(:playground_should_autoconnect?).returns(false)
  #     instance = Vanity::Playground.new(:connection=>"mock:/")
  #     assert !instance.connected?
  #   end
  # end
end