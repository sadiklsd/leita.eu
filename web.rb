require 'sinatra'
require 'sinatra/activerecord'
require 'pony'
db = URI.parse('postgres://rccbbtlniowhqb:ArygKC-v7LpmIYDYOwSZ0cdCdk@ec2-54-204-15-48.compute-1.amazonaws.com:5432/dcd604ki6e6j1k')
ActiveRecord::Base.establish_connection(
adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
host: db.host,
username: db.user,
password: db.password,
database: db.path[1..-1],
encoding: 'utf8'
)
class MyApp < Sinatra::Base
  get '/' do
    erb "#{File.read('views/index.erb')} #{File.read('views/contact.erb')}"
  end
  post '/mail' do
    content_type :json

    {"params" => params}
    hash=JSON.parse("{#{params.to_s.delete("\\\\{}").gsub('""','"')[/^(.*),"human"/,1]}}")
    ip=hash["ip"]
    name=hash["name"]
    email=hash["email"]
    text=hash["message"]


    Pony.mail :to =>'nicolas.roitero@gmail.com',
    :from => 'contact@leita.eu',
    :subject => "New mail from #{name} / ip: #{ip}",
    :body => "name: #{name}<br>email: <a href=\"mailto:#{email}\">#{email}</a><br>text: #{text}"
  end
end
