module RoverProject
  class MotorController

    attr_reader :motors
    def initialize(name, type, pins)
      @name = name
      @type = type
      @pins = pins

      @motors = []
    end
  end
end
