require_relative '../test_helper.rb'

class JQueryTest < Test::Unit::TestCase

    def setup
        test_dir = File.expand_path( File.join( File.dirname( __FILE__ ) ) + '/..' )

        data =<<EOHTML
    <html>
        <body>
            <script src='file://#{test_dir}/jquery/jquery.js'></script>

            <span id='test_span'>test span</span>

            <script>
                div = document.createElement( "div" );
                div.style.display="none";
                div.textContent = 'Test div';
                div.id = 'test_div';
                body = document.getElementsByTagName('body')[0];
                body.appendChild( div );
            </script>
        </body>
    </html>
EOHTML
         @window = DOM::Window.new( data )
    end

    def test_id_selector
        assert_equal 'test span', @window.eval( '$("#test_span").text();' )
    end

    def test_id_selector_and_element_creation
        assert_equal 'Test div', @window.eval( '$("#test_div").text();' )
    end

end
