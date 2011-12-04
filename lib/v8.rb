require 'v8'

class V8::Access

    #
    # JS catch all method
    #
    # Helps determine what functionality needs to be implemented.
    #
    alias :old_get :get
    def get( obj, name, &dontintercept )
        if !accessible_methods( obj ).include?( name ) && !obj.respond_to?( :[] )
            $stderr.puts "Not yet implemented: #{obj.class}.#{name}"
        end

        old_get( obj, name, &dontintercept )
    end
end
