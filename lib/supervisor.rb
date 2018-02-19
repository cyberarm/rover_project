module RoverProject
  class Supervisor
    def self.instance
      @instance if @instance
    end

    def self.instance=klass
      @instance = klass
    end

    attr_accessor :active_program
    attr_reader :sdl

    def initialize(host, port)
      Supervisor.instance = self
      @host = host
      @port = port
      @active_program = TeleOp.new#nil
      @run_supervisor = true

      log("Supervisor", "Supervisor at your service")
      run
    end

    def run
      log("Supervisor", "Starting ProgramServer...")
      Thread.new do
        ProgramServer.run!
        log("Supervisor", "ProgramServer stopped.")
        @run_supervisor = false
      end

      log("Supervisor", "Starting main loop...")
      while(@run_supervisor)
        if @active_program && @active_program.is_a?(Program)
          @active_program.loop
        end

        sleep 0.01 # sleep for 10 millisecond to let OS do stuff.
      end

      if @active_program && @active_program.is_a?(Program)
        @active_program.stop
        log("Supervisor", "Stopped #{@active_program.class}.")
      end
      log("Supervisor", "Exiting...")
    end
  end
end
