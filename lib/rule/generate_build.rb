require_relative "../path"

module Shog
  class GenerateBuild
    attr_accessor :deps

    def id
      :generate_build
    end

    def initialize
      @deps = PathSet.new
    end

    def rule
      {
        "command" => "cd .. && shog generate",
        "description" => "Generate Build Script",
      }
    end

    def target(params)
      output = PathSet.new
      output << Path.make("build.ninja", :outoftree => true, :root => true)
      variables = {
        "generator" => "1",
      }
      input = PathSet.new(params[:input])
      input += @deps
      {:rule => "generate_build", :input => input, :output => output, :variables => variables}
    end
  end
end
