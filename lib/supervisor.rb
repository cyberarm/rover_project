module RoverProject
  class Supervisor
    def self.instance
      @instance if @instance
    end

    def self.instance=klass
      @instance = klass
    end

    attr_accessor :active_program
    attr_reader :sdl_window, :host, :port

    def initialize(host, port)
      Supervisor.instance = self
      @host = host
      @port = port
      @active_program = nil
      @run_supervisor = true
      @sdl_window = nil
      SDL2.init(SDL2::INIT_EVERYTHING)

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
              log("Supervisor", "SDL received quit event, closing up shop...")
              @run_supervisor = false
              break
            when SDL2::Event::ControllerAxisMotion, SDL2::Event::ControllerButton, SDL2::Event::JoyDeviceAdded, SDL2::Event::JoyDeviceRemoved, SDL2::Event::ControllerDeviceAdded, SDL2::Event::ControllerDeviceRemoved
              @active_program.gamepad_event(event) if @active_program
            when SDL2::Event::KeyUp, SDL2::Event::KeyDown
              @active_program.keyboard_event(event) if @active_program
            when SDL2::Event::MouseButtonDown, SDL2::Event::MouseMotion, SDL2::Event::MouseButtonUp
              @active_program.mouse_event(event) if @active_program
            when SDL2::Event::Window
              # p event.inspect
            end
          end
          if @sdl_window.destroy?
            log("Supervisor", "Lost SDL window!")
            @run_supervisor = false
          end

          @sdl_window.show
          sleep 0.005
        end
      end

      log("Supervisor", "Starting main loop...")
      while(@run_supervisor)
        if @active_program && @active_program.is_a?(Program)
          @active_program.loop
          @active_program.last_loop_time = (Time.now - @active_program.loop_time)
          @active_program.loop_time = Time.now
          @active_program.hardware_interface.update_controllers
          @active_program.hardware_interface.reset_buttons
        end

        sleep 0.01 # sleep for 10 millisecond to let OS do stuff.
      end

      if @active_program && @active_program.is_a?(Program)
        @active_program.stop
        @active_program.halt!
        log("Supervisor", "Stopped #{@active_program.class}.")
      end
      ProgramServer.instance.shutdown
      while (EM.reactor_running?); end
      log("Supervisor", "Exiting...")
    end

    def set_program(klass)
      stop_program

      begin
        raise NameError unless Program.list.detect {|program| if program.to_s == klass.to_s; true; end}
        @active_program = Object.const_get(klass).new
        log("Supervisor", "Started #{@active_program.class}.")
      rescue NameError
        log("Supervisor", "'#{klass}' is not a known program.")
      end
    end

    def stop_program
      if @active_program && @active_program.is_a?(Program)
        log("Supervisor", "Stopping #{@active_program.class}...")
        @active_program.stop
        @active_program.halt!
        log("Supervisor", "Stopped #{@active_program.class}.")
        @active_program = nil
      end
    end

    def telemetry
      if @active_program
        the_telemetry = ""
        @active_program.hardware_interface.motor_controllers.each do |k, mc|
          the_telemetry << "Motor Controller #{mc.type}<br />"
          mc.motors.each do |motor|
            the_telemetry << "#{motor.name} motor, power: #{motor.power}, direction: #{motor.direction}<br />"
          end
          the_telemetry << "<br />"
          the_telemetry << "<br />"
        end
        {active_program: @active_program.class.to_s, telemetry: "#{the_telemetry}"}
      else
        {active_program: false, telemetry: ""}
      end
    end
  end
end
