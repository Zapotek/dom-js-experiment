require_relative 'init'
require 'test/unit'

#
# This is a test from Johnson
#
# @ee http://tenderlovemaking.com/2009/04/05/testing-javascript-outside-the-browser/
#
class OptionTagsAppendedTest < Test::Unit::TestCase

    def setup

        #
        # Taken from a Johnson example
        #
        data =<<EOHTML
      <html>
        <head>

          <script>
            function populateDropDown() {
                var select = document.getElementById('colors');
                var options = ['red', 'green', 'blue', 'black'];
                var i;

                for( i = 0; i < options.length; i++ ) {
                    var option = document.createElement( 'option' );
                    option.appendChild( document.createTextNode( options[i] ) );
                    option.value = options[i];
                    select.appendChild( option );
                }
            }

            div = document.createElement( "div" );
            div.style.display="none";
            div.textContent = 'Test div';
            body = document.getElementsByTagName('body')[0];
            body.appendChild( div );

           </script>
        </head>

        <body onload="populateDropDown()">

          <h1>Behold the V8</h1>

          <form>
            <select id="colors">
            </select>
          </form>

        </body>
      </html>
EOHTML

        @window = DOM::Window.new( data )
        @document = @window.document
    end

    def test_options_populated_by_onload
        # 0 option tags before onload is executed
        assert_equal 0, @document.getElementsByTagName('option').length

        # Execute the onload body attribute
        @window.eval @document.getElementsByTagName( 'body' ).first.onload

        # 4 option tags after onload is executed
        assert_equal 4, @document.getElementsByTagName('option').length
    end
end
