class Task < ActiveResource::Base
	# AwsSdbProxy settings
	self.site = "http://localhost:8888" # AwsSdbProxy host + port
    self.prefix = "/aws_todo/" # use your SimpleDB domain enclosed in /s
    
    # Specify a schema in order to always have accessor methods available to our callers.
    # (I.e. in view forms)
    SCHEMA = ['id', 'project_id', 'description', 'completed_at', 'created_at', 'updated_at']
    
    def initialize(attributes = {})
    	
    	# Loop through the schema and add any missing values into the attributes hash
    	for field in SCHEMA
    		attributes[field] = nil unless attributes.key?(field)
		end
    		
    	super(attributes)
    end
        
    attr_accessor :attributes
    
    def project
    	Project.find( :first, :params => { :id => self.project_id } )
    end
    
    protected #---------
    
    def validate
    	errors.add_on_empty %w( project_id, description )    	
    end
    
end