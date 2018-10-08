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


post '/api/v1/login' do
  login = @jsonBody['user']
  passw = @jsonBody['pass']

  puts login
  puts passw

  user = User.find(login: login)

  if user and user.authenticate?(passw)
    content_type :json
    { token: token(user) }.to_json
  else
    halt 401
  end
end


get '/' do
	"Hello World!"
end