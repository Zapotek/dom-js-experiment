require 'nokogiri'

#
# Monkey patch all elements to include a 'style' attribute
#
class Nokogiri::XML::Element
    attr_reader :style

    include ::DOM::Events

    class Style < OpenStruct
    end

    def initialize( *args )
        super
        @style = Style.new
    end
end
