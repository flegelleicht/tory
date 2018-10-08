require 'sinatra'
require 'sequel'
require 'json'
require 'jwt'

require_relative './auth'

configure do
	set :port, 4567
  set :bind, '0.0.0.0'
  set :db, Sequel.sqlite('db/database.db')

  require_relative './models/user'
  require_relative './models/event'

  if User.find(login: "test") == nil
    testUser = User.create do |u|
      u.login = "test"
      u.pass = "test"
    end
    ev = Event.new do |e|
      e.start = DateTime.parse('2018-10-08')
      e.end = DateTime.parse('2018-10-09')
      e.name = 'Probetag'
      e.description = 'Probetag von Erik'
      e.externalLink = 'https://github.com/flegelleicht/'
    end
    testUser.add_event(ev)
  end
end

use JwtAuth

##
# Try to parse the body of a request into JSON
## 
before do
  begin
    request.body.rewind
    @rawJsonBody = request.body.read
    @jsonBody = JSON.parse @rawJsonBody
  rescue JSON::ParserError
    @rawJsonBody = "{}"
    @jsonBody = {}
  end
end

##
# Every .js-file should have the correct Content-Type
##
before /.*\.js/ do
  content_type 'text/javascript'
end

def token(user)
  JWT.encode payload(user), 'QgxEteYw691PfQKC', 'HS256' #ENV['JWT_SECRET'], 'HS256'
end
  
def payload(user)
  {
    exp: Time.now.to_i + 60 * 60 * 24,
    iat: Time.now.to_i,
    iss: 'exercise.territory.de', #ENV['JWT_ISSUER'],
    user: {
      id: user.id
    }
  }
end

options '*' do
  headers "Allow" => "POST, OPTIONS"
  headers "Access-Control-Allow-Headers"  => "access-control-allow-origin"
  headers "Access-Control-Allow-Origin"   => "*"
  headers "Access-Control-Allow-Methods"  => "all"
  halt 200
end

post '/api/v1/public/login' do
  headers "Access-Control-Allow-Origin"   => "*"

  login = @jsonBody['user']
  passw = @jsonBody['pass']

  user = User.find(login: login)

  if user and user.authenticate?(passw)
    content_type :json
    { token: token(user) }.to_json
  else
    halt 401
  end
end

get '/api/v1/public/events' do
  headers "Access-Control-Allow-Origin"   => "*"
  content_type :json
  Event.all.map{|e| e.to_hash }.to_json
end


get '/api/v1/private/events' do
  content_type :json
  
  user = User.find(id: request.env[:user]['id'])
  if user
    events = user.events.map{|e| e.to_hash }.to_json
  else
    [400, { message: 'Please retry request'}.to_json]
  end
end

post '/api/v1/private/events' do
  content_type :json

  event = @jsonBody['event'];
  user = User.find(id: request.env[:user]['id'])

  if user and event

    ev = Event.new do |e|
      e.start = DateTime.parse(event['start'])
      e.end = DateTime.parse(event['end'])
      e.name = event['name']
      e.description = event['description']
      e.externalLink = event['link']
    end

    user.add_event(ev)

    [201, { message: 'Successful'}.to_json]
  else
    [400, { message: 'Please retry request'}.to_json]
  end
end

get '/' do
	send_file './public/index.html', :type => :html
end
