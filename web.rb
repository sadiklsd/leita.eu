# encoding: utf-8
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
    params
    ip=params["ip"]
    name=params["name"]
    email=params["email"]
    text=params["message"].gsub("\n","<br>")
    puts params

    Pony.mail :to =>'nicolas.roitero@gmail.com',
    :from => 'contact@leita.eu',
    :subject => "New mail from #{name} / ip: #{ip}",
    :html_body => "name: #{name}<br>email: <a href=\"mailto:#{email}\">#{email}</a><br>text: #{text}"
  end
  get '/upload' do
    erb :upload
  end
  post '/upload' do
    puts params.class
    params.each{|k|
      val= k[0]
      puts val
      File.open('public/uploads/' + params[val][:filename], "w") do |f|
        f.write(params[val][:tempfile].read)
      end
      redirect '/list'
    }
  end
  get '/list' do
    lines="<tr><td colspan=\"6\"><h1 style=\"text-align:center\">Uploads</h1></td></tr><tr><td>Image</td><td>Title</td><td>Description</td><td>Gallery</td><td>Update</td><td>Delete</td></tr>"
    options=""
    galleries=Dir.entries("public/imgz/")-[".",".."]
    galleries.sort.each{|folder|
      options+="<option>#{folder}</option>"

    }
    dir=Dir.entries("public/uploads/")-[".",".."]
    dir.each{|img|
      @test="<img width='100px' src='uploads/#{img}'/>"
      @img=img
      lines+="  <tr style=\"text-align:center\">
      <td>#{@test}</td><td>#{@img[/^(.*?)\(/,1]}</td><td>#{@img[/\((.*?)\)/,1]}</td><td><form><select class=\"btn btn-primary\"><option value="" disabled selected>Select your option</option>#{options}</select></form></td><td><a class=\"btn btn-warning\" href=\"/update/#{img}\">Update</a></td><td><a class=\"btn btn-danger\" href=\"/delete/#{img}\">Delete</a></td>
      </tr>"
    }
lines2=""
count=0
    gal=Dir.entries("public/imgz")-[".",".."]
    gal.sort.reverse.each { |gal_name|
      lines2+="<table class=\"table table-bordered table-hover\"><tr><td colspan=\"6\"><h1 style=\"text-align:center\">#{gal_name}</h1></td></tr>"



      dir=Dir.entries("public/imgz/#{gal_name}")-[".",".."]
      dir.each{|img|
        @test="<img width='50px' src='imgz/#{gal_name}/#{img}'/>"
        @img=img
        lines2+="  <tr class=\"n#{count}\" data-description=#{@img[/\((.*?)\)/,1]} data-title=\"#{@img[/^(.*?)\(/,1]}\" data-file=\"#{@img}\" style=\"text-align:center\">
        <td>#{@test}</td><td class=\"img_title editable\">#{@img[/^(.*?)\(/,1]}</td><td class=\"img_description editable\">#{@img[/\((.*?)\)/,1]}</td><td><form><select class=\"btn btn-primary select\"><option value="" disabled selected>Select your option</option>#{options}</select></form></td><td><a class=\"btn btn-warning update\" href=\"#\">Update</a></td><td><a class=\"btn btn-danger\" href=\"/delete/#{img}\">Delete</a></td>
        </tr>"
        count+=1
      }
  lines2+="</table>"

    }
    erb :list ,locals: {lines: lines,lines2: lines2}

  end
  get '/delete/:file' do
    puts `rm  public/uploads/"#{params["file"]}"`
    redirect '/list'
  end
end
