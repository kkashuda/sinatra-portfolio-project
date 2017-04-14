class UsersController < ApplicationController
  get '/signup' do
    if !logged_in?
      erb :'users/create_users'
    else
      redirect 'users/homepage'
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect to '/signup'
    else
      @user = User.create(params)
      @user.save
      session[:user_id] = @user.id
      redirect to '/'
    end
  end

  get '/login' do
    if !session[:user_id]
      erb :'/users/login'
    else
      redirect '/homepage'
    end
  end

  post '/login' do
    if !params[:username].empty? && !params[:password].empty?
      user = User.find(params[:username])
    end

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/homepage'
    else
      redirect '/signup'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end
