# frozen_string_literal: true

require_relative "MCServer/version"

module MCServer
  # class Error < StandardError; end
  # # Your code goes here...

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
  end
end
