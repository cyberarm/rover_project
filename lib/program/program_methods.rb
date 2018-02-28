module RoverProject
  module ProgramMethods
    # Tells program what HardwareInterface to use
    # @param interface_class [HardwareInterface] Only pass constant and NOT an instance of HardwareInterface
    # @return [HardwareInterface] Instance of hardware interface
    def use(interface_class)
      @hardware_interface = interface_class.new
    end

    # Get motor controller by name
    # @param name [Symbol] name of motor controller
    # @return [MotorController|nil] Returns the instance of motor controller
    def motor_controller(name)
      @hardware_interface.motor_controllers[name]
    end

    # Get motor by name
    # @param name [Symbol] name of motor
    # @return [Motor|nil] Returns the instance of motor
    def motor(name)
      @hardware_interface.motors[name]
    end

    # Get input by name
    # @param name [Symbol] name of input
    # @return [Input::GamePad|Input::Mouse|Input::Keyboard|nil] Returns the instance of input
    def input(name)
      @hardware_interface.inputs[name]
    end

    # Pauses execution of Progam.loop for the given seconds
    # @note motor controllers will be updated before delay starts.
    # @note input buttons will be reset before delay starts. (Input.released?(key) will be false after delay)
    # @param seconds [Integer|Float] Number of seconds to delay execution of program
    def delay(seconds)
      start_time = Time.now
      @hardware_interface.update_controllers
      @hardware_interface.reset_buttons
      until Time.now-start_time >= seconds || !@running
        sleep 0.01
      end
      throw(:ended_while_delayed) unless @running
    end

    # Plays sound using SDL2
    # @note A value of -1 will make sound repeat until the program stops.
    # @param sound_path [String] path to sound file
    # @param loops [Integer] number of times to repeat sound.
    def sound(sound_path, loops = 0)
      @audio.play_sound(sound_path, loops)
    end

    # Plays music using SDL2
    # @note A value of -1 will make song repeat until {music} is called again or the program stops.
    # @param music_path [String] path to music file
    # @param loops [Integer] number of times to repeat song.
    def music(music_path, loops = 0)
      @audio.play_music(music_path, loops)
    end

    # Speaks text using espeak (or cmd)
    # @param text [String] what to speak
    # @param cmd [String] command to use for speaking
    def speak(text, cmd = "espeak -ven+f3 -k5 -s150")
      Thread.new do
        system("#{cmd} \"#{text}\"")
      end
    end

    # Plays a beep at freq for duration
    # @note this uses the speaker-test program which lasts a max of 10.5 seconds and leaks its output to console. Looking into replacing with a more reliable solution
    # @param freq [Integer] frequency of beep (e.g. 440 is the freq of the A note in music)
    # @param duration [Integer|Float] number of seconds to play sound.
    def beep(freq, duration)
      Supervisor.instance.beep(freq, duration)
    end
  end
end
