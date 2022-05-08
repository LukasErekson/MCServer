# frozen_string_literal: true

require 'open3'

require_relative "MCServer/version"
require_relative "MCServer/server_not_started_error"
require_relative "MCServer/server_already_running_error"

module MCServer
  class MCServer
    attr_reader :pid, :path, :active

    def initialize(path = "~/Minecraft_Server")
      @path = path
      @pid = nil
      @active = false
    end

    def active?
      return @active = false if @pid.nil?

      @active = !!`ps -p #{@pid}`["\n"]
    end

    def start
      raise ServerAlreadyRunningError "A server instance is already running" if active?
      @read_io, @write_io = IO.pipe

      @pid = fork do
        STDIN.reopen(@read_io)
        STDOUT.reopen(@write_io)

        puts "Start server"
      end

      Process.detach(@pid)


      unless active?
        @pid = nil
        close
      end

      true
    end

    def close
      raise ServerNotStartedError "Cannot close the server; the server is not started" unless active?

      `kill #{@pid.to_i}` unless @pid.nil?
      @read_io.close
      @write_io.close

      @pid = nil

      true
    end

    def command(_command_str)
      raise ServerNotStartedError "Cannot send command; the server is not started" unless active?
    end
  end

  
end
