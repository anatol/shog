require_relative "../path"

module Shog
  class ObjCopy
    attr_accessor :bin

    def id
      :objcopy
    end

    def rule
      {
        "command" => "$bin -O $arch $in $out",
        "description" => "Objcopy $out",
      }
    end

    def target(params)
      input = PathSet.make(params[:input])
      output = if params[:output]
          PathSet.make(Path.make(params[:output], :outoftree => true))
        elsif params[:suffix]
          PathSet.make(Path.make(params[:input], :outoftree => true).with_suffix(params[:suffix]))
        else
          raise "Please either provide output name of suffix for output file"
        end

      variables = {
        "bin" => params[:bin] || @bin || "objcopy",
      }
      variables["arch"] = params[:arch] if params[:arch]
      { :rule => "objcopy", :input => input, :output => output, :variables => variables }
    end
  end
end
