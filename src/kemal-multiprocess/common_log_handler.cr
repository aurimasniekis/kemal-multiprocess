require "kemal/common_log_handler"

module Kemal::MultiProcess
  # Kemal::CommonLogHandler uses STDOUT by default and handles the logging of request/response process time.
  # It's also provides a `write` method for common logging purposes.
  class CommonLogHandler < Kemal::CommonLogHandler
    def call(context)
      time = Time.now
      call_next(context)
      elapsed_text = elapsed_text(Time.now - time)
      @handler << "[" << Process.pid << "] " << time << " " << context.response.status_code << " " << context.request.method << " " << context.request.resource << " " << elapsed_text << "\n"
      context
    end

    def write(message)
      @handler << "[" << Process.pid << "] " << message
    end
  end
end
