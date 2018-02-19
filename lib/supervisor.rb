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
      log("Supervisor", "Using SDL2 version: #{SDL2::LIBSDL_VERSION}")
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
      @sdl_window = SDL2::Window.create("RoverProject", SDL2::Window::POS_CENTERED,SDL2::Window::POS_CENTERED,100,100, 0)
      @sdl_window.raise

      Thread.new do
        while(@run_supervisor)
          while(event = SDL2::Event.poll)
            case event
            when SDL2::Event::Quit
              @run_supervisor = false
              break
            when SDL2::Event::ControllerAxisMotion, SDL2::Event::ControllerButton, SDL2::Event::ControllerDevice
              @active_program.gamepad_event(event) if @active_program
            when SDL2::Event::KeyUp, SDL2::Event::KeyDown
              @active_program.keyboard_event(event) if @active_program
            when SDL2::Event::MouseButtonDown, SDL2::Event::MouseMotion, SDL2::Event::MouseButtonUp
              @active_program.mouse_event(event) if @active_program
            end

            # sleep 1/100_000.0
          end
          sleep 0.005
        end
      end

      log("Supervisor", "Starting main loop...")
      while(@run_supervisor)
        if @active_program && @active_program.is_a?(Program)
          @active_program.loop
          @active_program.last_loop_time = (Time.now - @active_program.loop_time)
          @active_program.loop_time = Time.now
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
