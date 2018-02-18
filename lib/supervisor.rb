module RoverProject
  class Supervisor

    attr_accessor :active_program

    def initialize(host, port)
      @host = host
      @port = port
      @active_program = nil
      @run_supervisor = false

      log("Supervisor", "Supervisor at your service")
      run
    end

    def run
      log("Supervisor", "Starting ProgramServer...")
      Thread.new do
        ProgramServer.run
      end

      log("Supervisor", "Starting main loop...")
      while(@run_supervisor)
        if @active_program && @active_program.is_a?(Program)
          @active_program.loop
        end

        sleep 0.01 # sleep for 10 millisecond to let OS do stuff.
      end
      log("Supervisor", "Exiting...")
    end
  end
end
