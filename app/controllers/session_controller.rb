# This controller handles the login/logout function of the site.  
class SessionController < ApplicationController
	
	def new
		flash[:notice] = "Notice"
		if self.logged_in?
			redirect_to tasks_path
		end
	end
		
	def create
		password_authentication(params[:email], params[:password])
	end
	
	def destroy
		self.current_user.forget_me if logged_in?
		cookies.delete :auth_token
		reset_session
		flash[:notice] = "You have been logged out."
		redirect_back_or_default('/')
	end
	
	protected #------------------
	
	def password_authentication(email, password)
		self.current_user = User.authenticate(email, password)
		if logged_in?
			successful_login
		else
			failed_login
		end
	end
	
	def failed_login(message = "Authentication failed.")
		flash.now[:error] = message
		render :action => 'new'
	end
	
	def successful_login
		if params[:remember_me] == "1"
			self.current_user.remember_me
			cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
		end
		redirect_back_or_default('/')
		flash[:notice] = "Logged in successfully"
	end

end
