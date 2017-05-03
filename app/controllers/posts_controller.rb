require 'pry'
require 'rack-flash'

class PostsController < ApplicationController
	use Rack::Flash

	get '/posts' do
		if logged_in?
			@posts = Post.all
			erb :'users/show'
		else
			redirect to '/login'
		end
	end

	get '/posts/new' do
		if logged_in?
    	erb :'posts/new'
		else
			redirect '/login'
		end
  end

	post '/posts' do
		if params[:content].empty?
			flash[:message] = "Oops, you left the text box empty!"
			redirect '/posts/create_post'
		else
			@user = User.find(session[:user_id])
			@post = Post.create(:content => params[:content], :state=> params[:state], :user_id => @user.id)
			flash[:message] = "Your post has been successfully created!"
			redirect '/users/homepage'
		end
	end

	get '/users/homepage' do
		@posts = Post.all
		erb :'/users/show'
	end

	get '/posts/:id' do
		redirect to '/login' if !logged_in?
		@post = Post.find_by(id: params[:id])
		erb :'/posts/show' if @post.user == current_user 
		redirect to '/'
	end

	get '/users/:user_id/posts' do 
		 if session[:user_id]
      @posts = User.find(session[:user_id]).posts
      erb :'posts/show'
    else
      redirect to '/login'
    end
	end 

	get '/posts/:id/edit' do
		if session[:user_id]
			@post = Post.find_by(id: params[:id])
			erb :'posts/edit' if @post.user == current_user 
		else 
			binding.pry 

			redirect to '/login'
		end 
		
	end

	patch '/posts/:id' do
		redirect to '/login' if !logged_in?
		if params[:content].empty?
			flash[:message] = "Oops, you left the text box empty!"
			redirect to "/posts/#{params[:id]}/edit"
		else
			@post = Post.find_by_id(params[:id])
			if @post.user == current_user
				@post.update(content: params[:content])
				flash[:message] = "Your post has been updated!"
				redirect to "/posts"
			end
		end
	end

	get '/posts/:id/delete' do
		redirect to '/login' if !logged_in?
		@post = Post.find_by_id(params[:id])
		if @post.user == current_user 
			erb :'posts/delete'
		else 
			redirect to '/'
		end 
	end

	delete '/posts/:id/delete' do
		redirect to '/login' if !logged_in?
		@post = Post.find_by(id: params[:id])
		if @post.user == current_user
			@post.delete
			flash[:message] = "Your post has been deleted!"
			redirect '/posts'
		else
			flash[:message] = "Please don't ruin other peoples stuff"
			redirect '/'
		end
	end
end
