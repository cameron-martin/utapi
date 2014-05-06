require 'rattributes'

module UTApi
  class Persona
    include Rattributes.new(:persona_id, :persona_name)
  end
end