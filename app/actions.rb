helpers do
   def current_user
      User.find_by(id: session[:user_id])
   end
end


#Controller

get '/' do
   @finstagram_posts = FinstagramPost.order(created_at: :desc) 
   erb(:index)
end


get '/signup' do
   @user = User.new
   erb(:signup)

end

post '/signup' do
    # grab user input values from params
    email = params[:email]
    avatar_url = params[:avatar_url]
    username = params[:username]
    password = params[:password]


    #instantiate and save a user
    @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })

    if @user.save

      redirect to('/login')

    else
      erb(:signup)
    end
 end

 get '/login' do
   erb(:login)
 end

 post '/login' do
   username = params[:username]
   password = params[:password]
   
   #1.  Find by username
   @user = User.find_by(username: username)

   # 2.  If that user exists
   if @user && @user.password == password
   #if user && user.authenticate(password)
   session[:user_id] = @user.id   
      #login (more to come)
      #"Success!! User with id #{session[:user_id]} is logged in!!"
      redirect to('/')
   else 
     @error_message =  "Login Failed"
     erb(:login)
   end
end

get '/logout' do
   session[:user_id] = nil
   redirect to('/')

end

