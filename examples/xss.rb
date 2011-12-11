require_relative '../init'

html = <<EOHTML
<html>
    <head>
        <title>My title!</title>
    </head>

    <body>
        <div>
            <script type="text/javascript">
                document.write( navigator.userAgent );
            </script>
        </div>
    </body>
</html>
EOHTML

#
# the second param sets 'dont_eval_js' to true
#
window = DOM::Window.new( html, true )

#
# our XSS vector and our seed
#
# the seed is JS generated JS code just to showcase
# the possible viability of this system
#
window.navigator.userAgent = <<EOJS
    <script>
        method = 'al' + 'ert';
        params = "( 'Bo' + 'oya!' );"
        eval( method + params );
    </script>"
EOJS

#
# this will show the HTML as is
#
# puts window.document.to_html
# puts '-' * 80

#
# the following is not proper behavior but it'll have to do for now
#

# this one will run the initial JS (exec document.write)
# and add the new JS code to the page
window.instance_eval { exec_js! }

#
# this one will show the HTML updated with the new JS
#
# puts window.document.to_html
# puts '-' * 80

# this one will exec the JS code written by the first JS code
window.instance_eval { exec_js! }
#
# and should output 'Alert: Booya!' because the alert() JS function has been
# overridden to just output whatever it's passed.
#

#
# this one won't differ from the last one in this scenario
#
# puts window.document.to_html
