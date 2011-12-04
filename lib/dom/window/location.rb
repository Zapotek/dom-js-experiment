class DOM::Window::Location < DOM::Placeholder

    def initialize( url )
        @url = URI( url )
    end

    def host
        @url.host + ':' + @url.port.to_s
    end

    def hostname
        @url.host
    end

    def href
        @url.to_s
    end

    def path
        @url.path
    end

    def port
        @url.port
    end

    # def hash
        # return 0 if !@url.fragment
        # '#' + @url.fragment
    # end

    def search
        '?' + @url.query
    end

    def protocol
        @url.scheme + ':'
    end

    def to_s
        @url.to_s
    end

end
