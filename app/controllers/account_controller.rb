class AccountController < ApplicationController
	def signup
		@user = User.new
		if request.post?
			@user = User.new(params[:user].permit(:name,:email,:hashed_password,:password))
			
			if @user.save
				        Emailer.signup_confirmation(@user).deliver

				redirect_to :action=>"signin"
				
			else
				render :action=>"signup"
			end
		end
	end
	
	def signin
	if request.post?
		@user = User.authenticate(params[:user][:email],params[:user][:password])
		if @user
			session[:user]=@user
			redirect_to :action=>"index"
			
		else  
			flash[:notice] = "Invalid Username / Password"
		        render :action=>"signin"
			
		end
		end
	end
	
	def forgot_password
		if request.post?
			@user = User.find_by_email(params[:user][:email])
			if @user
			   new_password = random_password
			  puts new_password
			   @user.update(:password=>new_password)
				Emailer.forgot_password_send(@user,new_password).deliver
				flash[:notice] = "A new password has been sent your email"
			   redirect_to :action=>"signin"
			else
			   flash[:notice]="Invalid Email.Please enter correct email"
			   render :action=>"forgot_password"
			end
		
		end
		
	end
	
	def random_password
	   (0...8).map{65.+(rand(25)).chr}.join
		
	end
	
	def reset_password
		@user = User.find(session[:user])
		
		if request.post?			
			if @user.update_attributes(:password=>params[:user][:password])
			Emailer.reset_password_confirmation(@user).deliver
			flash[:notice] = "Your password has been reset"
			redirect_to :action=>"signin"
			
			else
				render :action=>"reset_password"
				
			end
		end
		
	end
	
	def logout
		session[:user]=nil
		flash[:notice]="You have Successfully logged out"
		redirect_to :action=>"signin"
		
	end
end
