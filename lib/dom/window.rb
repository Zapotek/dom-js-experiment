require 'open-uri'

class DOM::Window < DOM::Placeholder
end

require_relative 'window/document'
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

    def initialize( html = '', dont_eval_js = false )
        prep_document!( html )

        @dont_eval_js = dont_eval_js
        @navigator = Navigator.new

        @location = Location.new( '' )
        @document.location = Location.new( '' )

        # @event = Event.new
        @history = History.new
        finalize!
    end

    def open( url )
        prep_document!( Kernel::open( url ).read )
        @document.location = @location = Location.new( url )
        finalize!
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

    def eval( code )
        eval2( code, :embedded )
    end

    def window
        self
    end

    private

    def finalize!
        exec_js! if !@dont_eval_js
        ready!
    end

    def eval2( code, src, parent = nil )
        begin
            @js.eval( code )
        rescue Exception => e
            if e.respond_to?( :in_javascript? )
                show_js_frames( e, code, src )
            else
                $stderr.puts e
                $stderr.puts e.backtrace.join( "\n" )
            end

            puts
            puts '=' * 80
            puts
        end
    end

    def prep_document!( html )
        @document = Taka::DOM::HTML( html )
        @document.extend( DOM::Window::Document )

        @js = V8::Context.new( :with => self )
        @js['Image'] = DOM::Image
    end

    def ready!
        @document.close
        @readyState = 'complete'
    end

    #
    # Evaluates a HTML/JS code and returns the JS context and the DOM Window.
    #
    # @param    [String]     html_or_url    HTML code or URL to load
    #
    # @param    [Array]     [JavaScript context, DOM Window]
    #
    def exec_js!
        @document.xpath( './/script' ).each {
            |script|

            begin
                 src, code = *read_script( @document.location.href, script )
            rescue Exception => e
                $stderr.puts e
                $stderr.puts e.backtrace.join( "\n" )
                next
            end

            eval2( code, src )
        }
    end

    #
    # Converts 'link' to a absolute URL based on the 'root' URL.
    #
    def to_absolute( root, link )

        parsed =  URI.parse( link )
        if parsed.scheme == 'file'
           parsed.scheme = nil
           return parsed.to_s
        end

        return link if URI.parse( link ).host

        begin
            # remove anchor
            link = URI.encode( link.to_s.gsub( /#[a-zA-Z0-9_-]*$/,'' ) )

            base_url = URI.parse( URI.encode( root ) )
            relative = URI.parse( link )
            absolute = base_url.merge( relative )

            absolute.path = '/' if absolute.path && absolute.path.empty?

            return absolute.to_s
        rescue Exception => e
            $stderr.puts e
            $stderr.puts e.backtrace.join( "\n" )
            return nil
        end
    end

    def read_script( location, script )
        return if script['type'] && script['type'] != 'text/javascript'

        if src = script['src']
            src =  to_absolute( location.to_s, src ).to_s
            code = Kernel::open( src ).read
        else
            code = script.text
            src = :embedded
        end

        [src, code]
    end

    def show_js_frames( e, code, src = :embedded, context = 5 )
        lines = code.split( "\n" )

        errline = e.backtrace.first.split( ':' )[-2].to_i
        errcol  = e.backtrace.first.split( ':' ).last.to_i

        if src == :embedded
            puts 'Error in embedded script:'
            range  = Range.new( 0, lines.count )

            start = errline - context
            start = 0 if start < 0

            finish = context + errline
            finish = lines.count if finish > lines.count

            range  = Range.new( start, finish )
        else
            puts 'Error in script at: ' + src

            start = errline - context
            start = 0 if start < 0

            finish = context + errline
            finish = lines.count if finish > lines.count

            range  = Range.new( start, finish )
        end

        puts e.value.to_s + " -- at line #{errline}, column #{errcol}."
        puts

        puts 'Backtrace: '
        e.backtrace.each {
            |l|
            puts '    ' + l
        }

        if lr = lines[range]
            puts
            puts 'Code fragment:'
            lr.each_with_index {
                |line, i|

                ln = i + 1 + start

                print "#{ln} #{line}"

                if ln == errline
                    puts "    # <-- Error at column ##{errcol}"
                else
                    puts
                end

            }
        end

    end

end
