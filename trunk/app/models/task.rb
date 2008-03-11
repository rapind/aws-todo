class Task < ActiveResource::Base
	# AwsSdbProxy settings
	self.site = "http://localhost:8888" # AwsSdbProxy host + port
    self.prefix = "/aws_todo/" # use your SimpleDB domain enclosed in /s
    
    attr_accessor :attributes
    #attr_accessor :id, :list_id, :description, :completed_at, :created_at, :updated_at
    
    def list
    	List.find( :first, :params => { :id => self.list_id } )
    end
    
    protected #---------
    
    def validate
    	errors.add_on_empty %w( list_id, description )    	
    end
    
end