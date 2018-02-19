module RoverProject
  class Program
    PROGRAMS = []
    include ProgramMethods

    attr_reader :hardware_interface
    def initialize
      setup
      raise "No HardwareInterface!" unless @hardware_interface
    end

    def setup
    end

    def loop
    end

    def stop
      halt!
    end

    def halt!
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

    def method_added(symbol)
      raise "DO NOT OVERRIDE HALT!" if symbol == :halt! && self.methods.detect {|sym| if sym == :halt!; true; end}
      super
    end
  end
end
