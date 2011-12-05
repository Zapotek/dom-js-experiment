require 'uri'

module DOM

    #
    # Evaluates a HTML/JS code and returns the JS context and the DOM Window.
    #
    # @param    [String]     html_or_url    HTML code or URL to load
    #
    # @param    [Array]     [JavaScript context, DOM Window]
    #
    def eval_page( html_or_url )
        window = nil

        begin
            URI( html_or_url )
            window = DOM::Window.new.open( html_or_url )
        rescue
            window = DOM::Window.new( html_or_url )
        end

        document = window.document

        cxt = V8::Context.new( :with => window )
        cxt['Image'] = DOM::Image

        document.xpath( './/script' ).each {
            |script|

            begin
                 src, code = *read_script( document.location, script )
            rescue Exception => e
                $stderr.puts e
                $stderr.puts e.backtrace.join( "\n" )
                next
            end

            begin
                cxt.eval( code )
            rescue Exception => e
                show_js_frames( e, src, code )

                puts
                puts '=' * 80
                puts
            end
        }

        [cxt, window]
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

    private
    def read_script( location, script )
        return if script['type'] && script['type'] != 'text/javascript'

        if src = script['src']
            src =  to_absolute( location.to_s, src ).to_s
            code = open( src ).read
        else
            code = script.text
            src = :embedded
        end

        [src, code]
    end

    def show_js_frames( e, src, code, context = 5 )
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

    extend self
end

require 'ostruct'
require_relative 'dom/events'
require_relative 'dom/placeholder'
require_relative 'dom/image'
require_relative 'dom/window'

require_relative 'v8'
require_relative 'taka'
require_relative 'nokogiri'
