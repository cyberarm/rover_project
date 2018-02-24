module RoverProject
  class Error < RuntimeError
  end
  class ProgramEndedWhileDelayed < Error; end
end
