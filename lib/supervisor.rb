module RoverProject
  class Supervisor
    def self.instance
      @instance if @instance
    end

    def self.instance=klass
      @instance = klass
    end

    attr_accessor :active_program
    attr_reader :sdl_window

    def initialize(host, port)
      Supervisor.instance = self
      @host = host
      @port = port
      @active_program = TeleOp.new#nil
      @run_supervisor = true
      @sdl_window = nil

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

      log("Supervisor", "Creating SDL window for input reasons...")
      @sdl_window = SDL2::Window.create("RoverProject", 100,100,100,100, 0)
      @sdl_window.raise

      Thread.new do
        while(@run_supervisor)
          while(event = SDL2::Event.poll)
            case event
            when SDL2::Event::Quit
              @run_supervisor = false
              break
            when SDL2::Event::KeyUp
              @active_program.keyboard_event(event) if @active_program
            when SDL2::Event::KeyDown
              @active_program.keyboard_event(event) if @active_program
            end

            sleep 0.01
          end
        end
      end

      log("Supervisor", "Starting main loop...")
      while(@run_supervisor)
        if @active_program && @active_program.is_a?(Program)
          @active_program.loop
          @active_program.hardware_interface.reset_buttons
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
