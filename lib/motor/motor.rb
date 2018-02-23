module RoverProject
  class Motor
    ZERO_FUZZ = 8 # Motors might not move at a power less than this so act like its zero

    attr_reader :name, :port, :power, :direction
    alias :speed :power
    def initialize(initial_name, port, initial_power = 0, initial_direction = :forward)
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
    
    def pwm_speed
	  ((@power/255.0)*100.0).abs
	end

    # A power is a integer between -255 to +255
    def set_power(integer)
      raise "power must be a whole number (Integer)" unless integer.is_a?(Integer)
      @power = integer
    end

    # returns relative direction for motor given @direction and @power
    def direction
      if @direction == :forward
        if @power <= 0
          return :backward
        else
          return :forward
        end
      else
        if @power <= 0
          return :forward
        else
          return :backward
        end
      end
    end

    # Sets direction for motor, useful if motor's 'forward' is the inverse of what you want.
    # Direction is either :forward or :backward
    def set_direction(symbol)
      raise "Direction must ':forward' or ':backward'" unless symbol.is_a?(Symbol) && (symbol == :forward || symbol == :backward)
      @direction = symbol
    end
  end
end
