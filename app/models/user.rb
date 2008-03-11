require 'digest/sha1'
class User < ActiveResource::Base
	# AwsSdbProxy settings
	self.site = "http://localhost:8888" # AwsSdbProxy host + port
	self.prefix = "/aws_todo/" # SimpleDB domain
	
	attr_accessor :attributes
	#attr_accessor :id, ...
	
	# before a new user is created
	def create
		# TODO - validation on email and password
		make_activation_code
		encrypt_password
		super
	end
	
	def lists
		List.find( :all, :params => { :user_id => self.id } )
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
		u = find( :first, :params => { :email => email } ) # need to get the salt
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
		return if password.blank?
		self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") #if new_record?
		self.crypted_password = encrypt(password)
		self.password = nil
	end
		
	def make_activation_code
		self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
	end
    
end