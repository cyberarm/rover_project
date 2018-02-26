module RoverProject
  module ProgramMethods
    def use(interface_class)
      @hardware_interface = interface_class.new
    end

    def motor_controller(name)
      @hardware_interface.motor_controllers[name]
    end

    def motor(name)
      @hardware_interface.motors[name]
    end

    def input(name)
      @hardware_interface.inputs[name]
    end

    def delay(seconds)
      start_time = Time.now
      @hardware_interface.update_controllers
      @hardware_interface.reset_buttons
      until Time.now-start_time >= seconds || !@running
        sleep 0.01
      end
      throw(:ended_while_delayed) unless @running
    end

    def sound(sound_path, loops = 0)
      @audio.play_sound(sound_path, loops)
    end

    def music(music_path, loops = 0)
      @audio.play_music(music_path, loops)
    end

    def speak(text, cmd = "espeak -ven+f3 -k5 -s150")
      Thread.new do
        system("#{cmd} \"#{text}\"")
      end
    end
  end
end
