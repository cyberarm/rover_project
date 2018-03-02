module RoverProject
  class Supervisor
    include Logger
    BEEP_ERROR = 4_000
    BEEP_BOOT  = 840
    BEEP_START = 562
    BEEP_STOP  = 672
    BEEP_SHUTDOWN = 440
    def self.instance
      @instance if @instance
    end

    def self.instance=klass
      @instance = klass
    end

    attr_accessor :active_program
    attr_reader :audio, :sdl_window, :host, :port, :log_color, :tmpfs

    def initialize(host, port)
      SDL2.init(SDL2::INIT_GAMECONTROLLER|SDL2::INIT_EVENTS|SDL2::INIT_AUDIO)

      Supervisor.instance = self
      @host = host
      @port = port
      @active_program = nil
      @run_supervisor = true
      @sdl_window = nil
      @log_color = :cyan
      @audio = Audio.new

      log("Supervisor at your service")
      log("Using SDL2 version: #{SDL2::LIBSDL_VERSION}")

      log("Mounting tmpfs for beeps and boops...")
      log("Calling: 'sudo mount -t tmpfs -o size=64m tmpfs #{Dir.pwd}/data/tmp'")
      success = system("sudo mount -t tmpfs -o size=64m tmpfs #{Dir.pwd}/data/tmp")
      if success
        log("Mounted.")
        @tmpfs = true
      else
        log("Failed to mount!")
        @tmpfs = false
      end

      beep(BEEP_BOOT, 250)

      run
    end

    def run
      log("Starting ProgramServer...")
      Thread.new do
        ProgramServer.run!
        log("ProgramServer stopped.")
        @run_supervisor = false
      end

      Thread.new do
        while(@run_supervisor)
          while(event = SDL2::Event.poll)
            case event
            when SDL2::Event::Quit
              log("SDL received quit event, closing up shop...")
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
          sleep 0.005
        end
      end

      log("Starting main loop...")
      while(@run_supervisor)
        if @active_program && @active_program.is_a?(Program) && @active_program.running?
          begin
            catch(:ended_while_delayed) do
              @active_program.loop
              @active_program.last_loop_time = (Time.now - @active_program.loop_time)
              @active_program.loop_time = Time.now
              @active_program.hardware_interface.update_controllers
              @active_program.hardware_interface.reset_buttons
            end
          rescue => e
            log("=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=")
            log("An error occurred, program will be halted!".upcase)
            log(e)
            log("=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=")
            @active_program.halt! if @active_program && @active_program.is_a?(Program)
          end
        end

        sleep 0.01 # sleep for 10 millisecond to let OS do stuff.
      end

      if @active_program && @active_program.is_a?(Program)
        @active_program.stop
        @active_program.halt!
        log("Stopped #{@active_program.class}.")
      end
      ProgramServer.instance.shutdown
      log("Exiting...")
      beep(BEEP_SHUTDOWN, 500)
      @audio.teardown
      log("Unmounting tmpfs...")
      success = system("sudo umount #{Dir.pwd}/data/tmp")
      if success
        log("Unmounted.")
      else
        log("Failed to unmount! Not mounted?")
      end
    end

    def set_program(klass)
      stop_program
      valid_program = false

      begin
        Program.list.detect do |program|
          valid_program = true
          break
        end
        raise NameError unless valid_program
        @active_program = Object.const_get(klass).new
        log("Started #{@active_program.class}.")
        beep(BEEP_START, 200)
      rescue NameError
        log("'#{klass}' is KNOWN blame Object.const_get") if valid_program
        log("'#{klass}' is not a known program.") unless valid_program
        beep(BEEP_ERROR, 500)
      end
    end

    def stop_program
      if @active_program && @active_program.is_a?(Program)
        log("Stopping #{@active_program.class}...")
        @active_program.stop
        @active_program.halt!
        log("Stopped #{@active_program.class}.")
        beep(BEEP_STOP, 250)
        @active_program = nil
      end
    end

    # Plays beep/tone
    #
    # Available types: :sine, :square, :saw, :triangle, and :noise
    # @param freq [Integer] frequency of beep/tone
    # @param duration [Integer] length of beep/tone in milliseconds
    # @param type [Symbol] type of beep/tone
    def beep(freq, duration, type = :sine)
      tone = ToneGenerator.new(type: type, freq: freq, duration: duration/1000.0)
      @audio.play_sound(tone.filename, 0)
    end

    # Output the robots telemetry
    # @return [String] Telemetry
    def telemetry
      if @active_program
        the_telemetry = ""
        @active_program.hardware_interface.motor_controllers.each do |k, mc|
          the_telemetry << "<b>#{mc.name}</b> Motor Controller (#{mc.type})<br />"
          mc.motors.each do |motor|
            the_telemetry << "<b>#{motor.name}</b> Motor: power: #{motor.power}, direction: #{motor.direction}<br />"
          end
          the_telemetry << "<br />"
          the_telemetry << "<br />"
        end
        {active_program: @active_program.class.to_s, telemetry: "#{the_telemetry}", programs: Program.list.join(" ").split(" ")}
      else
        {active_program: false, telemetry: "", programs: Program.list.join(" ").split(" ")}
      end
    end
  end
end
