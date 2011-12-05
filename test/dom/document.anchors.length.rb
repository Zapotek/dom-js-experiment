require_relative '../test_helper.rb'

class AnchorsTest < Test::Unit::TestCase

    def setup
        data =<<EOHTML
    <html>
        <body>
            <a name="html">HTML Tutorial</a><br />
            <a name="css">CSS Tutorial</a><br />
            <a name="xml">XML Tutorial</a><br />
            <a id='w3s' href="/js/">JavaScript Tutorial</a>
        </body>
    </html>
EOHTML
         @js, window = *DOM.eval_page( data )
         @document = window.document
    end

    def test_anchors_count
        assert_equal 3, @document.anchors.length
        assert_equal 3, @js.eval( 'document.anchors.length' )
    end

    def test_first_anchors_inner_html
        txt = 'HTML Tutorial'
        assert_equal txt, @document.anchors[0].innerHTML
        assert_equal txt, @js.eval( 'document.anchors[0].innerHTML' )
    end

    def test_get_href
        href = '/js/'
        assert_equal href, @document.getElementById( 'w3s' ).href
        assert_equal href, @js.eval( "document.getElementById( 'w3s' ).href" )
    end
end
