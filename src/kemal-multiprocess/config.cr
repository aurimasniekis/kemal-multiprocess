require "kemal/config"

module Kemal::MultiProcess

  class Config < Kemal::Config
    property process_count : Int

    def initialize
      super

      @process_count = 2
    end

    private def setup_log_handler
      @logger ||= if @logging
                    Kemal::MultiProcess::CommonLogHandler.new
                  else
                    Kemal::NullLogHandler.new
                  end
      HANDLERS.insert(1, @logger.not_nil!)
    end
  end

  def self.config
    yield Config::INSTANCE
  end

  def self.config
    Config::INSTANCE
  end
end
