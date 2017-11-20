require_relative '../path'

module Shog
  class Link
    attr_accessor :bin, :implicit_input

    def initialize
      @implicit_input = PathSet.new
    end

    def id
      :ld
    end

    def rule
      {
        'command' => '$bin $ldflags $in -o $out',
        'description' => 'Linking $out',
      }
    end

    def target(params)
      output = PathSet.make(Path.make(params[:output], :outoftree => true))
      input = PathSet.make(params[:input])
      ldflags = params[:ldflags]
      if ldflags.nil?
        ldflags = ''
      elsif ldflags.is_a?(Array)
        ldflags = ldflags.join(' ')
      end
      variables = {
        'ldflags' => ldflags,
        'bin' => params[:bin] || @bin || 'gcc',
      }
      implicit_input = @implicit_input.dup
      implicit_input += params[:implicit_input] if params[:implicit_input]
      {:rule => 'ld', :input => input, :implicit_input => implicit_input, :output => output, :variables => variables}
    end
  end
end
