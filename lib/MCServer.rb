# frozen_string_literal: true

require_relative "MCServer/version"
require_relative "MCServer/server_not_started_error"

module MCServer
  class MCServer
    attr_reader :pid, :path, :active

    def initialize(path = "~/Minecraft_Server")
      @path = path
      @pid = nil
      @active = false
    end

    def active?
      @active
    end

    def command(_command_str)
      raise ServerNotStartedError "Cannot send command; the server is not started" unless active?
    end
  end
end
