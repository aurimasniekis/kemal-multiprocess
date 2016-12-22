require "./kemal-multiprocess/*"

module Kemal

  def self.runMultiProcess(port = nil)
    Kemal::MultiProcess::CLI.new
    config = Kemal::MultiProcess.config
    config.setup
    config.port = port if port

    config.server = HTTP::Server.new(config.host_binding, config.port, config.handlers)
    {% if !flag?(:without_openssl) %}
    config.server.tls = config.ssl
    {% end %}

    unless Kemal::MultiProcess.config.error_handlers.has_key?(404)
      error 404 do |env|
        render_404
      end
    end

    # Test environment doesn't need to have signal trap, built-in images, and logging.
    unless config.env == "test"
      Signal::INT.trap {
        log "Kemal is going to take a rest!\n"
        Kemal.stop
        exit
      }

      # This route serves the built-in images for not_found and exceptions.
      get "/__kemal__/:image" do |env|
        image = env.params.url["image"]
        file_path = File.expand_path("lib/kemal/images/#{image}", Dir.current)
        if File.exists? file_path
          send_file env, file_path
        else
          halt env, 404
        end
      end

      processes = [] of Process
      config.process_count.times do |num|
        process = Process.fork

        if process.nil?
          config.running = true
          config.server.listen
          exit
        else
          log "[#{config.env}] Kemal Process #{num} spawned"
        end

        processes << process
      end

      log "[#{config.env}] Kemal is ready to lead at #{config.scheme}://#{config.host_binding}:#{config.port}\n"

      processes.each do |process|
        process.wait
        log "[#{config.env}] Kemal Process #{process.pid} exited\n"
      end
    end
  end
end
