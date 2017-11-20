require_relative '../path'

module Shog
  class Yacc
    def id
      :yacc
    end

    def rule
      {
        'command' => 'yacc -o $out $in',
        'description' => 'Yacc $in',
      }
    end

    def target(params)
      input = PathSet.make(params[:input])
      output = PathSet.make(Path.make(params[:output], :outoftree => true))
      {:rule => 'yacc', :input => input, :output => output, :variables => {}}
    end
  end
end
