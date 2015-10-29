require 'pony'

    Pony.mail({ :to =>'nicolas.roitero@gmail.com',
    :from => 'sadiklsd@gmail.com',
    :subject => "New mail from",
    :body => "test",
    :via_options => {
   :address              => 'smtp.gmail.com',
   :port                 => '587',
   :enable_starttls_auto => true,
   :user_name            => 'sadiklsd',
   :password             => '$adiklsd25',
   :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
   :domain               => "leita.eu" # the HELO domain provided by the client to the server
 }
 })
