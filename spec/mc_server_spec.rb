# frozen_string_literal: true

require "spec_helper"

RSpec.describe MC_Server do
  it "has a version number" do
    expect(MC_Server::VERSION).not_to be nil
  end
end
