module RoverProject
  class Program
    PROGRAMS = []
    include ProgramMethods
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

    def method_added(symbol)
      raise "DO NOT OVERRIDE HALT!" if symbol == :halt! && self.methods.detect {|sym| if sym == :halt!; true; end}
      super
    end
  end
end
