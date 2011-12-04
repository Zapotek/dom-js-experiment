class DOM::Window::Navigator < DOM::Placeholder
    attr_accessor :userAgent

    def initialize
        @userAgent = 'Arachni'
    end
end
