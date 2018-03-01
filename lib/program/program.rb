module RoverProject
  class Program
    include Logger
    PROGRAMS = []
    def self.inherited(klass)
      PROGRAMS << klass
    end

    # List of programs
    def self.list
      PROGRAMS
    end

    include ProgramMethods

    attr_reader :hardware_interface
    attr_accessor :loop_time, :last_loop_time, :running

    def initialize
      @loop_time = Time.now
      @last_loop_time = 0
      @running = true
      @audio = Audio.new
      setup
      raise "No HardwareInterface!" unless @hardware_interface
    end

    # Setup for program, programs should implement this method instead of overriding {initialize}
    def setup
    end

    # This runs the program
    def loop
    end

    # This is called before halt! when a program stops
    def stop
    end

    # Returns true of the program is running
    def running?
      @running
    end

    # Called after stop when a program stops
    #
    # Don't override.
    def halt!
      @running = false
      @audio.teardown
      @hardware_interface.teardown
    end

    # Forwards sdl events to {Input::GamePad} instances
    # @param sdl_event [SDL2::Event]
    def gamepad_event(sdl_event)
      @hardware_interface.inputs.each do |k, klass|
        klass.event(sdl_event) if klass.is_a?(Input::GamePad)
      end
    end

    # Forwards sdl events to {Input::Keyboard} instances
    # @param sdl_event [SDL2::Event]
    def keyboard_event(sdl_event)
      @hardware_interface.inputs.each do |k, klass|
        klass.event(sdl_event) if klass.is_a?(Input::Keyboard)
      end
    end

    # Forwards sdl events to {Input::Mouse} instances
    # @param sdl_event [SDL2::Event]
    def mouse_event(sdl_event)
      @hardware_interface.inputs.each do |k, klass|
        klass.event(sdl_event) if klass.is_a?(Input::Mouse)
      end
    end

    def self.method_added(symbol)
      raise "DO NOT OVERRIDE HALT!" if symbol == :halt!
      super
    end
  end
end
