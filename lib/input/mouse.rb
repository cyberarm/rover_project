module RoverProject
  module Input
    class Mouse
      LEFT_BUTTON   = 0
      MIDDLE_BUTTON = 1
      RIGHT_BUTTON  = 2
      SCROLL_UP     = 3
      SCROLL_DOWN   = 4

      # @return [Integer] current mouse x position
      def x
      end

      # @return [Integer] current mouse x position
      def y
      end

      # @return [Boolean] Returns true if the `mouse_button` is pressed
      def holding?(mouse_button)
      end

      # @return [Boolean] Returns true if the `mouse_button` is recently released
      def released?(mouse_button)
      end
    end
  end
end
