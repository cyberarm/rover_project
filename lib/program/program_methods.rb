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
      until Time.now-start_time >= seconds
      end
    end
  end
end
