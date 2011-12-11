# DOM/JS Ruby experiment

This repo holds a few simple experiments I do on my spare time to see how easy it is to create a DOM/JS environment with/for Ruby.
The code is based on [Taka](https://github.com/Zapotek/taka) and the [V8 JS engine](http://code.google.com/p/v8/) as provided by [TheRubyRacer](https://github.com/cowboyd/therubyracer).

It goes without saying that the lib is far from usable.

# Dependencies

To install all dependencies run: ```bundle install```

# Examples

See the ```tests``` and ```examples``` directory for examples.

Here's a quickie:

```
require_relative 'init'

html = <<EOHTML
<html>
    <head>
        <title>My title!</title>
    </head>

    <body>
        <div>
            <script type="text/javascript">
                document.write( '<h1>Hello</h1>' );
            </script>
        </div>
    </body>
</html>
EOHTML

window = DOM::Window.new( html )

# you'll see the updated HTL code
puts window.document.to_html

puts '-' * 80

# grab the automatically added element
h1 = window.eval( 'document.getElementsByTagName( "h1" )[0]' )
puts 'The first H1 is: ' + h1

answer = ( h1 == window.document.getElementsByTagName( 'h1' )[0] ) ? 'Yes' : 'No'
puts 'Does it work both ways? ' + answer
```

# Author
Tasos "Zapotek" Laskos -- tasos.laskos@gmail.com
