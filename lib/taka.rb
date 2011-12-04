require 'taka'

#
# Taka lacks a few important interfaces
# so I've added some rough ones for the test's sake
#
module Taka::DOM::Document
    include ::DOM::Events

    attr_accessor :location
end
