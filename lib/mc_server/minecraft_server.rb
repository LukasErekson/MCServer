# frozen_string_literal: true

class Minecraft_Server
  attr_reader :pid, :path, :active, :log

  def initialize(path = "#{Dir.home}/Minecraft_Server")
    @path = path
    @pid = nil
    @active = false
  end

  def active?
    return @active = false if @pid.nil?

    @active = !!`ps -p #{@pid}`["\n"]
  end

  def start(ram_size = "4G")
    if active?
      raise ServerAlreadyRunningError "A server instance is already running. To start antoher server, please create a new object instance"
    end

    @read_io, @write_io = IO.pipe

    @pid = start_command(ram_size)

    Process.detach(@pid)

    @log = File.new("logs/latest.log")

    stop unless active?

    true
  end

  def stop
    raise ServerNotStartedError "Cannot close the server; the server is not started" unless active?

    @write_io.puts "/stop"
    @read_io.close
    @write_io.close
    @log.close

    @pid = nil

    true
  end

  def command(command_str)
    raise ServerNotStartedError "Cannot send command; the server is not started" unless active?

    root_command = command_str.split[0]
    return false unless MC_Server::VALID_COMMANDS.include? root_command

    @write_io.puts command_str

    true
  end

  protected

  def start_command(ram_size = "4G")
    Dir.chdir(path)

    fork do
      $stdin.reopen(@read_io)
      $stdout.reopen(@write_io)

      `java -Xmx#{ram_size} -Xms#{ram_size} -jar #{path}/server.jar --nogui`
    end
  end
end
