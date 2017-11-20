module Shog
  class Ninja
    attr_reader :backend_file

    def initialize
      @out_dir = 'out'
      @backend_file = File.join(@out_dir, 'build.ninja')
    end

    def configured?
      File.exists?(@backend_file)
    end

    def emitter
      Emitter.new(@backend_file)
    end

    def run
      system "ninja -C #{@out_dir}"
    end

    class Emitter
      def initialize(file)
        @out = File.open(file, 'w')
      end

      def finish
        @out.close
      end

      def default(target)
        unless target.empty?
          @out.puts "default #{target.join(' ')}"
          @out.puts
        end
      end

      def rule(r)
        vars = r.rule
        @out.puts "rule #{r.id.to_s}"
        for k, v in vars
          @out.puts "  #{k}=#{v}"
        end
        @out.puts
      end

      def emit(target)
        rule = target[:rule]
        input = target[:input].join(' ')
        implicit_input = if target[:implicit_input] and not target[:implicit_input].empty?
                           ' | ' + target[:implicit_input].join(' ')
                         else
                           ''
                         end
        output = target[:output].join(' ')
        variables = target[:variables]
        @out.puts "build #{output}: #{rule} #{input}#{implicit_input}"
        for k, v in variables
          @out.puts "  #{k}=#{v}"
        end if variables
        @out.puts
      end
    end
  end
end
