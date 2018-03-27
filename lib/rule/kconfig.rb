require_relative "../path"

module Shog
  class Kconfig
    def id
      :kconfig
    end

    def initialize
      @ldflags = []
    end

    def rule
      {
        "command" => "KCONFIG_CONFIG=$out conf --oldconfig -s $in",
        "description" => "Generate .config file",
      }
    end

    def target(params)
      output = PathSet.new(Path.make(params[:output]))
      input = PathSet.new(Path.make(params[:input]))
      {:rule => "kconfig", :input => input, :output => output}
    end

    def self.parse(file)
      config = {}
      for line in IO.readlines(file)
        next if line.start_with?("#")
        if line =~ /^CONFIG_(.*?)=(.*)$/
          key = $1.to_sym
          val = $2
          case val
          when "y" then val = true
          when /^\d+$/ then val = val.to_i
          when /^\"(.*)\"$/ then val = $1
          end
          config[key] = val
        end
      end
      config
    end
  end
end
