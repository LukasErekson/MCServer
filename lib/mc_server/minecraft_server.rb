# frozen_string_literal: true

class Minecraft_Server
  attr_reader :pid, :path, :active, :read_io, :write_io

  def initialize(path = "#{Dir.home}/Minecraft_Server")
    @path = path
    @pid = nil
    @active = false
  end

  def active?
    return @active = false if @pid.nil?

    @active = !!`ps -p #{@pid}`["\n"]
  end

  def start
    if active?
      raise ServerAlreadyRunningError "A server instance is already running. To start antoher server, please create a new object instance"
    end

    @pid = start_command

    Process.detach(@pid)

    unless active?
      @pid = nil
      close
    end

    true
  end

  def close
    raise ServerNotStartedError "Cannot close the server; the server is not started" unless active?

    @write_io.puts "/stop"
    @read_io.close
    @write_io.close

    @pid = nil

    true
  end

  def command(_command_str)
    raise ServerNotStartedError "Cannot send command; the server is not started" unless active?
  end

  protected

  def start_command
    @read_io, @write_io = IO.pipe

    Dir.chdir(path)

    fork do
      $stdin.reopen(@read_io)
      $stdout.reopen(@write_io)

      `java -jar #{path}/server.jar --nogui`
    end
  end
end
