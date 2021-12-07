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
   #if @user && @user.password == password - this is for non-encrypted password - before bcrypt was installed.
   if @user && @user.authenticate(password)
      session[:user_id] = @user.id
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

get '/finstagram_posts/new' do
   @finstagram_post = FinstagramPost.new
   erb(:"finstagram_posts/new")
end

post '/finstagram_posts' do
   photo_url = params[:photo_url]

   @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })

   if @finstagram_post.save
      redirect(to('/'))
   else
      erb(:"finstagram_posts/new")
   end
end

get '/finstagram_posts/:id' do
   @finstagram_post = FinstagramPost.find(params[:id])
   erb(:"finstagram_posts/show")
end

post '/comments' do
   # point values from params to variables
   text = params[:text]
   finstagram_post_id = params[:finstagram_post_id]

   #instantiate a comment with those values and assign the comment to 'current user'
   comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })
   comment.save
   redirect(back)

end

post '/likes' do
   finstagram_post_id = params[:finstagram_post_id]

   like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })
   like.save

   redirect(back)
end

delete '/likes/:id' do
   like = Like.find(params[:id])
   like.destroy
   redirect(back)
end
