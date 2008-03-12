class Task < ActiveResource::Base
	include ActiveResourceSchema
	
	# AwsSdbProxy settings
	self.site = "http://localhost:8888" # AwsSdbProxy host + port
    self.prefix = "/aws_todo/" # use your SimpleDB domain enclosed in /s
    
    # Specify a schema in order to always have accessor methods available to our callers.
    # (I.e. in view forms)
    @@schema = %w{id project_id description completed_at created_at updated_at}
    
    attr_accessor :attributes
    
    def project
    	Project.find( :first, :params => { :id => self.project_id } )
    end
    
    protected #---------
    
    def validate
    	errors.add_on_empty %w( project_id, description )    	
    end
    
end