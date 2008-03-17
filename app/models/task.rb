class Task < ActiveResource::Base
	# Specify the default schema attributes for the class. This ensures that these attributes are available
	# in view forms etc.
	include ActiveResourceSchema
	@@defaults = {
		:id => nil,
		:user_id => nil,
		:name => nil,
		:worth => 1,
		:completed_at => nil,
		:created_at => nil,
		:updated_at => nil
	}
	
	# AwsSdbProxy settings
	self.site = "http://localhost:8888" # AwsSdbProxy host + port
    self.prefix = "/aws_todo/" # use your SimpleDB domain enclosed in /s
    
    #def worth
    #	if worth
    #		self.worth.to_i
    #	else
    #		nil
    #	end
    #end
    
    attr_accessor :attributes
    
    def completed?
    	return true if self.completed_at
    	return false
    end
    
    def user
    	User.find( :first, :params => { 'id' => self.user_id } )
    end
    	
    protected #---------
    
    #def validate
    #	errors.add_on_empty %w( user_id, name, value )    	
    #end
    
end