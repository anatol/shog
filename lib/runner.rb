require_relative "ninja"
require_relative "generator"

module Shog
  module Runner
    WORKDIR = "out"

    def generate(backend)
      Dir.mkdir(WORKDIR) unless Dir.exists?(WORKDIR)
      gen = Generator.new(backend)
      gen.generate
    end

    def run(argv)
      unless File.exists?("shog.build")
        puts "shog.build file is not found in #{Dir.pwd}"
        exit 1
      end

      backend = Ninja.new

      cmd = argv[0]
      if cmd == "generate"
        generate(backend)
        return
      end

      generate(backend) unless backend.configured?
      backend.run
    end

    module_function :run, :generate
  end
end
