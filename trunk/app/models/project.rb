class Project < ActiveResource::Base
	include ActiveResourceSchema
	
	# AwsSdbProxy settings
	self.site = "http://localhost:8888" # AwsSdbProxy host + port
    self.prefix = "/aws_todo/" # use your SimpleDB domain enclosed in /s
    
    # Specify a schema in order to always have accessor methods available to our callers.
    # (I.e. in view forms)
    @@schema = %w{ id user_id name created_at updated_at } #['id', 'user_id', 'name', 'created_at', 'updated_at']
    
    attr_accessor :attributes
    
    def user
    	User.find( :first, :params => { 'id' => self.user_id } )
    end
    
    def tasks
    	Task.find( :all, :params => { 'project-id' => self.id } )
    end
    
    def incomplete_tasks
    	Task.find( :all, :params => { 'project-id' => self.id, 'completed-at' => nil } )
    end
    
    #def complete_tasks
    #	Task.find( :all, :params => { :project_id => self.id, :completed_at => "" } )
    #end
    
end
