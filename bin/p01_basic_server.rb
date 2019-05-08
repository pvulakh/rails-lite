require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  res.write(req.path) # used to be 'Hello world!', path method returns literal path of HTTP request
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
