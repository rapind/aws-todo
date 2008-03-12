class Project < ActiveResource::Base
	# AwsSdbProxy settings
	self.site = "http://localhost:8888" # AwsSdbProxy host + port
    self.prefix = "/aws_todo/" # use your SimpleDB domain enclosed in /s
    
    # Specify a schema in order to always have accessor methods available to our callers.
    # (I.e. in view forms)
    SCHEMA = ['id', 'user_id', 'name', 'created_at', 'updated_at']
    
    def initialize(attributes = {})
    	
    	# Loop through the schema and add any missing values into the attributes hash
    	for field in SCHEMA
    		attributes[field] = nil unless attributes.key?(field)
		end
    		
    	super(attributes)
    end
    
    attr_accessor :attributes
    
    def user
    	User.find( :first, :params => { :id => self.user_id } )
    end
    
    def tasks
    	Task.find( :all, :params => { :project_id => self.id } )
    end
    
    def incomplete_tasks
    	Task.find( :all, :params => { :project_id => self.id, :completed_at => nil } )
    end
    
    #def complete_tasks
    #	Task.find( :all, :params => { :project_id => self.id, :completed_at => "" } )
    #end
    
end
