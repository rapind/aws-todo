class List < ActiveResource::Base
	# AwsSdbProxy settings
	self.site = "http://localhost:8888" # AwsSdbProxy host + port
    self.prefix = "/aws_todo/" # use your SimpleDB domain enclosed in /s
    
    attr_accessor :attributes
    #attr_accessor :id, :user_id, :title, :description, :created_at, :updated_at
    
    def user
    	User.find( :first, :params => { :id => self.user_id } )
    end
    
    def tasks
    	Task.find( :all, :params => { :list_id => self.id } )
    end
    
    def incomplete_tasks
    	Task.find( :all, :params => { :list_id => self.id, :completed_at => nil } )
    end
    
    #def complete_tasks
    #	Task.find( :all, :params => { :list_id => self.id, :completed_at => "" } )
    #end
        
end
