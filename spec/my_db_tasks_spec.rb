require "spec_helper"

RSpec.describe MyDbTasks do
  it "has a version number" do
    expect(MyDbTasks::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
