module RoverProject
  module Input
    class Mouse
      LEFT_BUTTON   = "1"
      MIDDLE_BUTTON = "2"
      RIGHT_BUTTON  = "3"
      # SCROLL_UP     = 3
      # SCROLL_DOWN   = 4

      attr_reader :keys
      def initialize(options = {})
        @keys = {}
        @x, @y = 0, 0
      end

      def event(sdl_event)
        case sdl_event
        when SDL2::Event::MouseButtonUp
          @keys[sdl_event.button.to_s] = :released
        when SDL2::Event::MouseButtonDown
          @keys[sdl_event.button.to_s] = :holding
        when SDL2::Event::MouseMotion
          @x, @y = sdl_event.x, sdl_event.y
        end
        # puts "Button ID: #{sdl_event.button.to_s}" if defined?(sdl_event.button)
      end

      # @return [Integer] current mouse x position
      def x
        if SDL2::Mouse.global_state.x != nil
          SDL2::Mouse.global_state.x
        else
          @x
        end
      end

      # @return [Integer] current mouse x position
      def y
        if SDL2::Mouse.global_state.y != nil
          SDL2::Mouse.global_state.y
        else
          @y
        end
      end

      # @param mouse_button [String]
      # @return [Boolean] Returns true if the `mouse_button` is pressed
      def holding?(mouse_button)
        if @keys[mouse_button] && @keys[mouse_button] == :holding
          true
        else
          false
        end
      end

      # @param mouse_button [String]
      # @return [Boolean] Returns true if the `mouse_button` is recently released
      def released?(mouse_button)
        if @keys[mouse_button] && @keys[mouse_button] == :released
          @keys[mouse_button] = nil
          true
        else
          false
        end
      end
    end
  end
end
