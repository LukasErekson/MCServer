# frozen_string_literal: true

require_relative "MCServer/version"

module MCServer
  # class Error < StandardError; end
  # # Your code goes here...

  class MCServer
    attr_reader :pid, :path

    def initialize(path = "~/Minecraft_Server")
      @path = path
      @pid = nil
    end
  end
end
