# -*- coding: utf-8 -*-
$LOAD_PATH.unshift( File.dirname(__FILE__) )

ENV["ENVIRONMENT"] = "test"

require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'config', 'boot') )

# require "putsinator"

def debug_me
  require 'ruby-debug'
  debugger
end
