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
# we want to do that ourselves later on after we've prepared the vectors
# (navigator.userAgent in this case)
#
window = DOM::Window.new( html, true )

#
# our XSS vector and our seed
#
window.navigator.userAgent = <<EOJS
    <h1>Injected heading!</h1>
EOJS

#
# this will show the HTML as is
#
puts window.document.to_html
puts '-' * 80

# this one run all JS
window.instance_eval { exec_js! }

#
# this one will show the updated HTML i.e. including our injected h1
#
puts window.document.to_html
puts '-' * 80
