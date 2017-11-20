require_relative 'util'
require_relative 'pathset'

module Shog
  # An instance of this class is visible to our build scripts with name @shog
  class Context
    attr_accessor :default_target, :rule, :config

    def initialize(backend, emitter)
      @backend = backend
      @emitter = emitter

      @rule = {}
      @default_target = PathSet.new
      @config = {}
    end

    def register_rule(type)
      r = type.new
      @emitter.rule(r)
      @rule[r.id] = r
    end

    def bind
      binding
    end

    def visit_dir(dir, new_ctx = true)
      old_pwd = Path.pwd
      ctx = new_ctx ? deep_clone() : self

      Path.pwd = File.join(Path.pwd, dir)
      script = cwd('shog.build')
      @rule[:generate_build].deps << script
      script_name = script.path
      build_script = File.read(script_name)
      out = ctx.bind.eval(build_script, script_name)

      Path.pwd = old_pwd

      return out
    end

    def visit(dirs)
      case dirs
      when String then visit_dir(dirs)
      when Array then dirs.map { |d| visit_dir(d) }.flatten
      else raise "Unknown object type for dirs: #{dirs.class.name}"
      end
    end

    def cwd(src)
      Path.make(src)
    end

    def emit(rule_id, src, params = {})
      r = @rule[rule_id]
      raise "Rule #{rule_id} is not registered" unless r

      params[:input] = PathSet.make(src)
      target = r.target(params)
      # fix path to inputs, outputs, includes

      @emitter.emit(target)
      return target[:output]
    end

    def emit_each(rule_id, srcs, params = {})
      out = []
      for s in srcs
        p = params.dup
        p[:input] = s
        out += emit(rule_id, s, p)
      end
      return out
    end

    def deep_clone
      ctx = Context.new(@backend, @emitter)
      ctx.rule = @rule.deep_clone
      ctx.rule[:generate_build].deps = @rule[:generate_build].deps # deps are global across the build
      ctx.default_target = @default_target.deep_clone
      ctx.config = @config
      ctx
    end
  end
end
