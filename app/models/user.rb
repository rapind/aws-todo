require 'digest/sha1'
class User < ActiveResource::Base
	# Specify the default schema attributes for the class. This ensures that these attributes are available
	# in view forms etc.
	include ActiveResourceSchema
	@@defaults = {
		:id => nil,
		:email => nil,
		:full_name => nil,
		:password => nil,
		:salt => nil,
		:crypted_password => nil,
		:activated => false,
		:activation_code => nil,
		:activated_at => nil,
		:remember_token => false,
		:remember_token_expires_at => nil
	}

	# Sample user	
	# u = User.create(:email => 'rapind@gmail.com', :password => 'test', :full_name => 'Dave Rapin')
	
	# AwsSdbProxy settings
	self.site = "http://localhost:8888" # AwsSdbProxy host + port
	self.prefix = "/aws_todo/" # SimpleDB domain
	
	attr_accessor :attributes
	
	# before a new user is created
	def create
		# TODO - validation on email and password
		make_activation_code
		encrypt_password
		super
	end
	
	def tasks
		Task.find( :all, :params => { 'user-id' => self.id } )
	end
	
	def task_totals
		tasks = tasks
		tasks.inject(0){ |sum, item| sum + item.value }
	end
  
	# Activates the user in the database.
	def activate
		@activated = true
		self.activated_at = Time.now.utc
		self.activation_code = nil
		save(false)
	end

	def active?
		# the existence of an activation code means they have not activated yet
		activation_code.nil?
	end

	# Returns true if the user has just been activated.
	def pending?
		@activated
	end

	# Authenticates a user by their email and unencrypted password.  Returns the user or nil.
	def self.authenticate(email, password)
		u = find( :first, :params => { 'email' => email } ) # need to get the salt
		u && u.authenticated?(password) ? u : nil
	end

	# Encrypts some data with the salt.
	def self.encrypt(password, salt)
		Digest::SHA1.hexdigest("--#{salt}--#{password}--")
	end

	# Encrypts the password with the user salt
	def encrypt(password)
		self.class.encrypt(password, salt)
	end

	def authenticated?(password)
		crypted_password == encrypt(password)
	end

	def remember_token?
		remember_token_expires_at && Time.now.utc < remember_token_expires_at 
	end

	# These create and unset the fields required for remembering users between browser closes
	def remember_me
		remember_me_for 2.weeks
	end

	def remember_me_for(time)
		remember_me_until time.from_now.utc
	end

	def remember_me_until(time)
		self.remember_token_expires_at = time
		self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
		save(false)
	end

	def forget_me
		self.remember_token_expires_at = nil
		self.remember_token            = nil
		save(false)
	end

	protected #------------------
  
	# before filter 
	def encrypt_password
		#return unless self.password && self.email
		self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--")
		self.crypted_password = encrypt(password)
		self.password = nil
	end
		
	def make_activation_code
		self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
	end
    
end