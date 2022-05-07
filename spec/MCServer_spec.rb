# frozen_string_literal: true

require "spec_helper"

RSpec.describe MCServer do
  it "has a version number" do
    expect(MCServer::VERSION).not_to be nil
  end

  describe "#new" do
    let(:path) { "~/Minecraft_Server" }
    let(:server) { MCServer::MCServer.new }

    it "creates a MCServer object with empty pid" do
      expect(server.pid).to eq nil
    end

    it "has a default path of ~/Minecraft_Server" do
      expect(server.path).to eq path
    end

    it "defaults active to false" do
      expect(server.active?).to be false
    end
  end

  describe "#command" do
    describe "when given an inactive server" do
      let(:server) { MCServer::MCServer.new }

      it "raises a ServerNotStartedError" do
        expect { server.command "/list" }.to raise_error(proc { ServerNotStartedError.new })
      end
    end
  end
end
