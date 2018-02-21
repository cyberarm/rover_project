module RoverProject
  class ProgramServer < Sinatra::Base
    connections = []

    def self.instance
      @instance
    end
    def self.instance=(klass)
      @instance = klass
    end

    def initialize
      ProgramServer.instance = self
      super
    end

    def shutdown
      EM.stop if EM.reactor_running?
    end

    get "/" do
      slim :index
    end

    post "/program" do
      if params[:program]
        log("ProgramServer", "Asking Supervisor to start '#{params[:program]}'...")
        Supervisor.instance.set_program(params[:program])
      elsif params[:stop]
        log("ProgramServer", "Asking Supervisor to stop '#{Supervisor.instance.active_program.class}'...")
        Supervisor.instance.stop_program
      else
        log("ProgramServer", "Bad request.")
      end

      204
    end

    get "/telemetry", provides: "text/event-stream" do
      stream(:keep_alive) do |out|
        log("ProgramServer", "Streaming client connected...")
        EM::add_periodic_timer(0.1) do
          out << "data: #{Oj.dump(Supervisor.instance.telemetry, mode: :strict)}\n\n"
        end
        out.callback do
          log("ProgramServer", "Streaming client disconnected.")
        end
      end
    end

    get "/css/application.css" do
      sass :application
    end
  end
end
