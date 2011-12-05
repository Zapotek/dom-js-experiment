require 'open-uri'

class DOM::Window < DOM::Placeholder
end

require_relative 'window/frames'
require_relative 'window/history'
require_relative 'window/location'
require_relative 'window/navigator'

class DOM::Window

    attr_reader :document
    attr_reader :navigator
    attr_reader :event
    attr_reader :history

    attr_reader :readyState

    attr_accessor :location

    def initialize( html = '' )
        @document  = Taka::DOM::HTML( html )
        @navigator = Navigator.new

        @location = Location.new( '' )
        @document.location = Location.new( '' )

        # @event = Event.new
        @history = History.new

        ready!
    end

    def open( url )
        @document = Taka::DOM::HTML( Kernel::open( url ) )
        @document.location = @location = Location.new( url )
        ready!
        self
    end

    def top
        self
    end

    def frames
        self
    end

    def setTimeout( code, delay, *args )
        # sleep( delay / 1000 )

        # ap code
        # ap self.eval_js( code )
    end

    def setInterval( code, delay, *args )
        # sleep( delay / 1000 )

        # ap code
        # ap self.eval_js( code )
    end

    def alert( msg )
        puts 'Alert: ' + msg
    end

    def debug( obj )
        pp obj
    end

    def debug_type( obj )
        pp obj.class
    end

    def window
        self
    end

    private

    def ready!
        @readyState = 'complete'
    end

end
