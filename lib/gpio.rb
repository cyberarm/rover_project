class RPi
  class GPIO
    BCM = 0
    BOARD = 1

    LOW = false
    HIGH= true

    def self.set_mode(mode)
      @mode = mode
    end

    def getmode
      @mode
    end

    def cleanup
    end
  end
end
