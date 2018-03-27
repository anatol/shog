require "pathname"

module Shog
  class Path
    @pwd = "."

    class << self
      attr_accessor :pwd
    end

    attr_reader :path, :outoftree, :absolute

    private :initialize

    def initialize(path, outoftree, absolute = false)
      @path = path
      @outoftree = outoftree
      @absolute = absolute
    end

    def self.normalize(path)
      Pathname.new(path).cleanpath.to_s
    end

    def self.make(path, params = {})
      if path.is_a?(String)
        abolute = false
        if params.key?(:absolute) and params[:absolute]
          path = File.expand_path(path)
          absolute = true
        elsif not params.key?(:root) and not params[:root]
          path = File.join(Path.pwd, path)
        end
        path = Path.normalize(path)
        outoftree = if params.key?(:outoftree)
                      params[:outoftree]
                    else
                      false # by default we assume input file
                    end
        return Path.new(path, outoftree, absolute)
      elsif path.is_a?(Path)
        if params.key?(:outoftree) and params[:outoftree] != path.outoftree
          return Path.new(path.path, params[:outoftree])
        else
          return path
        end
      elsif path.is_a?(PathSet)
        return self.make(path.single_path, params)
      else
        raise "Cannot make path from #{path}"
      end
    end

    def dir
      path = File.dirname(@path)
      Path.new(path, @outoftree)
    end

    def with_suffix(suffix)
      Path.new(Path.normalize(@path + suffix), @outoftree)
    end

    def to_str
      # as we build files by ninja from inside outoftree directory then outs should not have any prefixes, but inputs should be accessed by '../'
      if @outoftree or @absolute
        @path
      else
        File.join("..", @path)
      end
    end
  end
end
