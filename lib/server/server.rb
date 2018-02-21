module RoverProject
  class ProgramServer < Sinatra::Base
    get "/" do
      if params[:program]
        log("ProgramServer", "Asking Supervisor to start '#{params[:program]}'...")
        Supervisor.instance.set_program(params[:program])
      end

      slim :index
    end
  end
end
