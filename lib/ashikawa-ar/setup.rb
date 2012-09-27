require "ashikawa-core"

module Ashikawa
  module AR
    def self.raw_setup(name, database)
      Setup.databases[name] = database
    end

    def self.setup(name, location)
      Setup.databases[name] = Ashikawa::Core::Database.new location
    end

    class Setup
      class << self; attr_accessor :databases end
      @databases = {}
    end
  end
end
