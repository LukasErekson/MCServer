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

  describe "#start" do
    context "when the server has not been started" do
      before(:all) do
        @server = MCServer::MCServer.new
        @success = @server.start
      end

      it "returns true upon successful start" do
        expect(@success).to be true
      end

      it "assigns a process id to server" do
        expect(@server.pid).not_to eq nil

        expect(@server.pid.class).to eq Integer
      end

      it "changes server.active? to be true" do
        expect(@server.active?).to be true
      end

      after(:all) do
        @server.close
      end
    end

    context "when a sever is already started" do
      before(:all) do
        @server = MCServer::MCServer.new
        @server.start
      end

      it "raises a ServerAlreadyRunning error" do
        expect { @server.start }.to raise_error(proc { ServerAlreadyRunningError.new })
      end

      after(:all) do
        @server.close
      end
    end
  end

  describe "#close" do
    context "when the server is running" do
      before(:each) do
        @server = MCServer::MCServer.new
        @server.start
      end

      it "returns true upon successful close" do
        expect(@server.close).to be true
      end

      it "reassigns the process id to nil" do
        expect { @server.close }.to change { @server.pid }.to(nil)
      end

      it "changes server.active? to be false" do
        expect { @server.close }.to change { @server.active? }.to(false)
      end

      after(:all) do
        @server&.close
      end
    end

    context "when the server is not running" do
      let(:server) { MCServer::MCServer.new }

      it "raises a ServerNotStartedError" do
        expect { server.close }.to raise_error(proc { ServerNotStartedError.new })
      end
    end
  end

  describe "#command" do
    context "when given an inactive server" do
      let(:server) { MCServer::MCServer.new }

      it "raises a ServerNotStartedError" do
        expect { server.command "/list" }.to raise_error(proc { ServerNotStartedError.new })
      end
    end
  end
end
