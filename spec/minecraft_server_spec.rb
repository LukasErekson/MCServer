# frozen_string_literal: true

require "spec_helper"
require "stringio"

RSpec.describe Minecraft_Server do
  describe "#new" do
    let(:server) { Minecraft_Server.new }

    it "creates a mc_server object with empty pid" do
      expect(server.pid).to eq nil
    end

    it "has a default path of ~/Minecraft_Server" do
      expect(server.path).to match(%r{/home/.*/Minecraft_Server})
    end
  end

  describe "#command" do
    context "when given an inactive server" do
      let(:server) { Minecraft_Server.new }

      it "raises a ServerNotStartedError" do
        expect { server.command "/list" }.to raise_error(proc { ServerNotStartedError.new })
      end
    end

    context "when given an active server" do
      before(:all) do
        @server = Minecraft_Server.new
        @server.start
      end

      xit "the server receives the command" do
        sleep(1) until @server.log.readline.include? "Done"

        @server.command "/list"
        @server.log.rewind

        reg_ex = /.*There are 0 of a max of \d+ players online: \n/
        expect(@server.log.readlines.any? { |line| line =~ reg_ex }).to be true
      end

      it "returns true for a valid sent command" do
        expect(@server.command("/list")).to be true
      end

      it "returns false for an invalid command" do
        expect(@server.command("give me diamonds")).to be false
      end

      it "calls #stop when given stop command" do
        expect(@server).to receive(:stop).and_return(true)
        @server.command("/stop")
      end

      after(:all) do
        @server.stop
      end
    end
  end

  describe "#start" do
    context "when the server has not been started" do
      before(:each) do
        @server = Minecraft_Server.new
        allow_any_instance_of(Minecraft_Server).to receive(:start_command).and_return(2)
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

      after(:each) do
        @server.stop
      end
    end

    context "when a sever is already started" do
      before(:each) do
        @server = Minecraft_Server.new
        allow_any_instance_of(Minecraft_Server).to receive(:start_command).and_return(2)
        allow(@server).to receive(:active?).and_return true
      end

      it "raises a ServerAlreadyRunning error" do
        expect { @server.start }.to raise_error(proc { ServerAlreadyRunningError.new })
      end
    end
  end

  describe "#stop" do
    context "when the server is running" do
      before(:each) do
        @server = Minecraft_Server.new
        allow_any_instance_of(Minecraft_Server).to receive(:start_command).and_return(2)
        @server.start
      end

      it "returns true upon successful stop" do
        expect(@server.stop).to be true
      end

      it "reassigns the process id to nil" do
        expect { @server.stop }.to change { @server.pid }.to(nil)
      end

      it "changes server.active? to be false" do
        expect { @server.stop }.to change { @server.active? }.to(false)
      end

      after(:all) do
        @server&.stop
      end
    end

    context "when the server is not running" do
      let(:server) { Minecraft_Server.new }

      it "raises a ServerNotStartedError" do
        expect { server.stop }.to raise_error(proc { ServerNotStartedError.new })
      end
    end
  end

  describe "#players" do
    context "when the server is running" do
      before(:each) do
        @server = Minecraft_Server.new
        allow(@server).to receive(:active?).and_return(true)

        allow(@server).to receive(:command).and_return(true)
      end

      it "returns empty array for 0 players" do
        @server.instance_variable_set(:@log,
                                      StringIO.new("[21:36:26] [Server thread/INFO]: There are 0 of a max of 20 players online: "))

        expect(@server.players).to eq([])
      end

      it "returns an array of player names for several players" do
        @server.instance_variable_set(:@log,
                                      StringIO.new("[21:36:26] [Server thread/INFO]: There are 0 of a max of 20 players online: Dream GeorgeNotFound Sapnap Technoblade"))

        expect(@server.players).to eq(%w[Dream GeorgeNotFound Sapnap Technoblade])
      end
    end

    context "when the server is not running" do
      let(:server) { Minecraft_Server.new }

      it "raises a ServerNotStarterError" do
        expect { server.players }.to raise_error(proc { ServerNotStartedError.new })
      end
    end
  end
end
