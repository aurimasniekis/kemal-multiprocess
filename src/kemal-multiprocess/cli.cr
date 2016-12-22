require "option_parser"
require "kemal/cli"

module Kemal::MultiProcess

  class CLI < Kemal::CLI
    def initialize
      @config = Konfig::MultiProcess.config
    end

    def parse
      super

      OptionParser.parse! do |opts|
        opts.on("-n COUNT", "--num-process COUNT", "Number of processes to run (defaults to 2)") do |opt_num|
          @config.process_count = opt_num.to_i
        end
      end
  end
end
