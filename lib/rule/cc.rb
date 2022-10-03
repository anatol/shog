require_relative "../path"

module Shog
  class CC
    attr_accessor :cflags, :includes, :implicit_input, :bin

    def id
      :cc
    end

    def initialize
      @cflags = []
      @includes = PathSet.new
      @implicit_input = PathSet.new
    end

    def rule
      {
        "command" => "$bin $cflags -MMD -MQ $out -MF $out.d -c $in -o $out",
        "description" => "Compile $in",
        "deps" => "gcc",
        "depfile" => "$out.d",
      }
    end

    def target(params)
      input = PathSet.new
      input << params[:input]

      output = PathSet.new
      if params[:output]
        output << Path.make(params[:output], :outoftree => true)
      else
        output << Path.make(params[:input].single_path, :outoftree => true).with_suffix(".o")
      end

      cflags = @cflags.dup
      cflags << params[:cflags] if params[:cflags]
      cflags += @includes.map { |i| "-I" + i }
      includes = params[:includes]
      if includes
        includes = PathSet.make(includes)
        cflags += includes.map { |i| "-I" + i }
      end

      variables = {
        "cflags" => cflags.join(" "),
        "bin" => params[:bin] || @bin || "gcc",
      }
      implicit_input = @implicit_input.dup
      implicit_input += params[:implicit_input] if params[:implicit_input]
      { :rule => "cc", :input => input, :implicit_input => implicit_input, :output => output, :variables => variables }
    end
  end
end
