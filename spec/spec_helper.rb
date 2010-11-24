# -*- coding: utf-8 -*-
$LOAD_PATH.unshift( File.dirname(__FILE__) )
ENV["ENVIRONMENT"] = "test"

# require "putsinator"

def debug_me
  require 'ruby-debug'
  debugger
end
