module RoverProject
  module Input
    class GamePad

      attr_reader :index, :type, :keys, :buttons, :axis
      def initialize(index = 0, type = :ps4)
        if SDL2::Joystick.num_connected_joysticks == 0
          log("GamePad", "No controller detected, exiting...")
          exit
        end
        @index = index
        @type  = type

        @min_joystick_axis = -32768.0
        @max_joystick_axis =  32767.0
        @max_axis_value    = 255

        @keys = {} # Actives the same as mouse and keyboard
        @buttons = {} # holds only boolean values
        @axis = {} # holds values of axis

        joystick = SDL2::Joystick.open(index)
          guid = joystick.GUID
          log("Gamepad", "Joystick/Gamepad GUID: #{joystick.GUID}")
        joystick.close
        # Mappings from https://github.com/gabomdq/SDL_GameControllerDB/blob/master/data/SDL_gamecontrollerdb2.0.4.h
        # PS4 Controller
        case type
        when :ps4
          SDL2::GameController.add_mapping("#{guid},PS4 Controller,a:b0,b:b1,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b10,leftshoulder:b4,leftstick:b11,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b12,righttrigger:a5,rightx:a3,righty:a4,start:b9,x:b3,y:b2,")
        else
          SDL2::GameController.add_mapping("#{guid},XInput Controller,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,")
        end

        @controller = SDL2::GameController.open(index)
      end

      def event(sdl_event)
        # p sdl_event.inspect
        return unless defined?(sdl_event.which) && sdl_event.which == index

        case sdl_event
        when SDL2::Event::ControllerAxisMotion
          axis = SDL2::GameController.axis_name_of(sdl_event.axis)
          @axis[axis] = sdl_event.value
          # p "#{axis} -> #{sdl_event.value}"
        when SDL2::Event::ControllerButton
          button = SDL2::GameController.button_name_of(sdl_event.button)
          p button
          @keys[button] = sdl_event.pressed ? :holding : :released
          @buttons[button] = sdl_event.pressed
        when SDL2::Event::ControllerDevice
          p sdl_event
        end
      end

      # @return [Boolean] Returns true if the `key_string` is pressed
      def holding?(key_string)
        if @keys[key_string] && @keys[key_string] == :holding
          true
        else
          false
        end
      end

      # @return [Boolean] Returns true if the `key_string` is recently released
      def released?(key_string)
        if @keys[key_string] && @keys[key_string] == :released
          @keys[key_string] = nil
          true
        else
          false
        end
      end

      # @return [Integer] between -255 to +255
      def left_stick_x
        if @axis["leftx"]
          if @axis["leftx"] <= 0
            ((@axis["leftx"]/@min_joystick_axis)*@max_axis_value).round
          else
            ((@axis["leftx"]/@max_joystick_axis)*@max_axis_value).round
          end
        else
          0
        end
      end

      # @return [Integer] between -255 to +255
      def left_stick_y
        if @axis["lefty"]
          axis = @axis["lefty"]*-1
          if axis < 0
            -((axis/@min_joystick_axis)*@max_axis_value).round
          else
            ((axis/@max_joystick_axis)*@max_axis_value).round
          end
        else
          0
        end
      end

      # @return [Integer] between -255 to +255
      def right_stick_x
        if @axis["rightx"]
          if @axis["rightx"] <= 0
            ((@axis["rightx"]/@min_joystick_axis)*@max_axis_value).round
          else
            ((@axis["rightx"]/@max_joystick_axis)*@max_axis_value).round
          end
        else
          0
        end
      end

      # @return [Integer] between -255 to +255
      def right_stick_y
        if @axis["righty"]
          axis = @axis["righty"]*-1
          if axis < 0
            -((axis/@min_joystick_axis)*@max_axis_value).round
          else
            ((axis/@max_joystick_axis)*@max_axis_value).round
          end
        else
          0
        end
      end

      # @return [Boolean] Returns true if the `left_stick` is pressed
      def left_stick
        @buttons["leftstick"]
      end

      # @return [Boolean] Returns true if `guide` is pressed
      def guide
        @buttons["guide"]
      end

      # @return [Boolean] Returns true if the `right_stick` is pressed
      def right_stick
        @buttons["rightstick"]
      end

      # @return [Boolean] Returns true if the `left_bumper` is pressed
      def left_bumper
        @buttons["leftshoulder"]
      end

      # @return [Boolean] Returns true if the `right_bumper` is pressed
      def right_bumper
        @buttons["rightshoulder"]
      end

      # @return [Integer] between 0 to 255
      def left_trigger
        if @axis["lefttrigger"]
          ((@axis["lefttrigger"]/@max_joystick_axis)*@max_axis_value).round
        else
          0
        end
      end

      # @return [Integer] between 0 to 255
      def right_trigger
        if @axis["righttrigger"]
          ((@axis["righttrigger"]/@max_joystick_axis)*@max_axis_value).round
        else
          0
        end
      end

      # @return [Boolean] Returns true if the `pause` button is pressed
      def pause
        @buttons["pause"]
      end

      # @return [Boolean] Returns true if the `start` button is pressed
      def start
        @buttons["start"]
      end

      # @return [Boolean] Returns true if the `dpad_left` is pressed
      def dpad_left
        @buttons["dpleft"]
      end

      # @return [Boolean] Returns true if the `dpad_right` is pressed
      def dpad_right
        @buttons["dpright"]
      end

      # @return [Boolean] Returns true if the `dpad_up` is pressed
      def dpad_up
        @buttons["dpup"]
      end

      # @return [Boolean] Returns true if the `dpad_down` is pressed
      def dpad_down
        @buttons["dpdown"]
      end

      # @return [Boolean] Returns true if the `x` button is pressed
      def x
        @buttons["x"]
      end

      # @return [Boolean] Returns true if the `y` button is pressed
      def y
        @buttons["y"]
      end

      # @return [Boolean] Returns true if the `b` button is pressed
      def b
        @buttons["b"]
      end

      # @return [Boolean] Returns true if the `a` button is pressed
      def a
        @buttons["a"]
      end
    end
  end
end
