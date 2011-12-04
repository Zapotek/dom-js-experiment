require_relative 'init'
require 'test/unit'

require_relative 'files/body.onload.rb'

#
# This is a test from Johnson
#
# @ee http://tenderlovemaking.com/2009/04/05/testing-javascript-outside-the-browser/
#
class OptionTagsAppendedTest < Test::Unit::TestCase

    def setup
        @js, window = *DOM.eval_page( body_onload )
        @document = window.document
    end

    def test_options_populated_by_onload
        # 0 option tags before onload is executed
        assert_equal 0, @document.getElementsByTagName('option').length

        # Execute the onload body attribute
        @js.eval @document.getElementsByTagName( 'body' ).first.onload

        # 4 option tags after onload is executed
        assert_equal 4, @document.getElementsByTagName('option').length
    end
end
