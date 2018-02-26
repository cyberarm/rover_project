module RoverProject
  class Program
    include Logger
    PROGRAMS = []
    def self.inherited(klass)
      PROGRAMS << klass
    end

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

    def setup
    end

    def loop
    end

    def stop
    end

    def running?
      @running
    end

    def halt!
      @running = false
      @audio.teardown
      @hardware_interface.teardown
    end

    def gamepad_event(sdl_event)
      @hardware_interface.inputs.each do |k, klass|
        klass.event(sdl_event) if klass.is_a?(Input::GamePad)
      end
    end

    def keyboard_event(sdl_event)
      @hardware_interface.inputs.each do |k, klass|
        klass.event(sdl_event) if klass.is_a?(Input::Keyboard)
      end
    end

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
