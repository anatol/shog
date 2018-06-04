require_relative "context"
require_relative "rule/cc"
require_relative "rule/link"
require_relative "rule/objcopy"
require_relative "rule/kconfig"
require_relative "rule/generate_build"
require_relative "rule/yacc"

module Shog
  class Generator
    def initialize(backend)
      @backend = backend
    end

    def generate
      emitter = @backend.emitter
      ctx = Context.new(@backend, emitter)

      if File.exists?("Kconfig") and not File.exists?(".config")
        success = system("conf --alldefconfig -s Kconfig")
        exit 1 unless success
      end

      # Register all rules
      ctx.register_rule(CC)
      ctx.register_rule(Link)
      ctx.register_rule(ObjCopy)
      ctx.register_rule(Kconfig)
      ctx.register_rule(GenerateBuild)
      ctx.register_rule(Yacc)

      Path.pwd = "."
      ctx.visit_dir(".", false)

      emitter.default(ctx.default_target)

      emitter.finish
    end
  end
end
