
def body_onload
    #
    # Taken from a Johnson example
    #
    <<EOHTML
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

end