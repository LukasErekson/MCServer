# frozen_string_literal: true

##
# Minecraft server instance that allows commands to be sent to the server.
class Minecraft_Server
  attr_reader :pid, :path, :log

  ##
  # Sets the path of the Minecraft_Server instance.
  def initialize(path = "#{Dir.home}/Minecraft_Server")
    @path = path
    @pid = nil
  end

  ##
  # Checks whether the server is active. That is a current instance is running.
  def active?
    return false if @pid.nil?

    !!`ps -p #{@pid}`["\n"]
  end

  ##
  # Starts a server instance and saves instance variables such as PID and the
  # log file.
  #
  # @param String : How many GB of ram to allocate for the server. e.g - 4GB
  def start(ram_size = "4G")
    if active?
      raise ServerAlreadyRunningError "A server instance is already running. To start antoher server, please create a new object instance"
    end

    @read_io, @write_io = IO.pipe

    @pid = start_command(ram_size)

    Process.detach(@pid)

    sleep(3) # Wait for a new latest.log to start.

    @log = File.new("logs/latest.log")

    stop unless active?

    true
  end

  ##
  # Stops the active server instance and closes and open IO prots.
  def stop
    raise ServerNotStartedError "Cannot close the server; the server is not started" unless active?

    @write_io.puts "/stop"
    @read_io.close
    @write_io.close
    @log.close

    @pid = nil

    true
  end

  ##
  # Sends a given command to the server to run. Only allows commands from the
  # valid list of commands.
  #
  # @param String : The full command to send to the server.
  def command(command_str)
    raise ServerNotStartedError "Cannot send command; the server is not started" unless active?

    root_command = command_str.split[0]

    return stop if root_command == "/stop"

    return false unless MC_Server::VALID_COMMANDS.include? root_command

    @write_io.puts command_str

    true
  end

  ##
  # Return an array of online player names on the server.
  def players
    raise ServerNotStartedError "Cannot retreive players; there is no running server instance" unless active?

    return @log.readlines[-1].split[13...] if command "/list"

    []
  end

  protected

  ##
  # Creates a new process for the Minecraft server instance
  #
  # @param String : The amount of RAM to allocate to the server instance.
  def start_command(ram_size = "4G")
    Dir.chdir(path)

    fork do
      $stdin.reopen(@read_io)
      $stdout.reopen(@write_io)

      `java -Xmx#{ram_size} -Xms#{ram_size} -jar #{path}/server.jar --nogui`
    end
  end
end
