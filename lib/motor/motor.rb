module RoverProject
  class Motor
    BACKWARD = 0
    FORWARD  = 1

    ZERO_FUZZ = 8 # Motors might not move at a power less than this so act like its zero

    attr_reader :name, :port, :power, :direction
    alias :speed :power
    def initialize(initial_name, port, initial_power = 0, initial_direction = FORWARD)
      set_name(initial_name)
      @port = port
      set_power(initial_power)
      @initial_direction = initial_direction
      set_direction(initial_direction)
    end

    def name
      @name
    end

    def set_name(symbol)
      raise "Name must be a symbol" unless symbol.is_a?(Symbol)
      @name = symbol
    end

    def power
      @power
    end

    # A power is a integer between -255 to +255
    def set_power(integer)
      raise "power must be a whole number (Integer)" unless integer.is_a?(Integer)
      @power = integer
    end

    # returns relative direction for motor given @direction and @power
    def direction
      if @direction == FORWARD
        if @power <= 0
          return BACKWARD
        else
          return FORWARD
        end
      else
        if @power <= 0
          return FORWARD
        else
          return BACKWARD
        end
      end
    end

    # Sets direction for motor, useful if motor's 'forward' is the inverse of what you want.
    # Direction is either 1 or 0.
    # 0 for BACKWARD and 1 for FORWARD
    def set_direction(integer)
      raise "Direction must 1 or 0" unless integer.is_a?(Integer) && (integer == FORWARD || integer == BACKWARD)
      @direction = integer
    end
  end
end
