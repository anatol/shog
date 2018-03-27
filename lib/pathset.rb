require_relative "path"

module Shog
  class PathSet < Array
    def self.make(set)
      if set.is_a?(PathSet)
        set
      elsif set.is_a?(Path)
        ary = PathSet.new
        ary << set
        ary
      elsif set.is_a?(Array)
        set.map { |p| Path.make(p) }
      elsif set.is_a?(String)
        ary = PathSet.new
        ary << set
        ary
      else
        raise "Unknown path type #{set.class}"
      end
    end

    def <<(p)
      if p.is_a?(PathSet)
        self.concat(p)
      elsif p.is_a?(Path)
        self.push(p)
      elsif p.is_a?(Array)
        p.each { |p| self.push(Path.make(p)) }
      elsif p.is_a?(String)
        self.push(Path.make(p))
      else
        raise "Unknown path type #{p}"
      end
    end

    def single_path
      raise "Expected number of paths is 1" if self.size != 1
      self[0]
    end

    def +(ary)
      self.concat(PathSet.make(ary))
    end
  end
end
