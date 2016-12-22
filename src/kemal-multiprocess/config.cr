require "kemal/config"

module Kemal::MultiProcess

  class Config < Kemal::Config
    INSTANCE = Config.new

    property process_count

    def initialize
      super

      @process_count = 2
    end

    def process_count
      @process_count
    end

    def process_count=(process_count : Int32)
      @process_count = process_count
    end
  end

  def self.config
    yield Config::INSTANCE
  end

  def self.config
    Config::INSTANCE
  end
end
