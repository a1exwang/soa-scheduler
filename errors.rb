require 'sinatra'
require 'json'

class MyError < Exception
  attr_accessor :message
  def initialize(str)
    self.message = str
  end
end

def er(str)
  raise MyError.new str
end

set show_exceptions: :after_handler

error JSON::JSONError do
  { status: :failed, reason: 'json format error' }.to_json
end
error MyError do
  e = env['sinatra.error']
  { status: :failed, reason: e.message }.to_json
end
error do
  e = env['sinatra.error']
  { status: :failed, reason: 'format error', e: e }.to_json
end
not_found do
  status 404
  { status: :not_found }.to_json
end