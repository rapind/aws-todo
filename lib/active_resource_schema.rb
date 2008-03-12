# This module can be included in ActiveResource model classes to initialize attributes to nil
# so they work with view forms etc.
#
# You just need to define a @@schema string array for the attribute names in the including class.
#
# For example if you have a project class that always has 'first_name' and 'last_name' attributes 
# you can add it to the schema so that calls to Project.new.first_name and Project.new.last_name 
# return nil instead of method not found exceptions.
#
# class Project < ActiveResource::Base
#   include ActiveResourceInit
#   @@schema = %w{ first_name last_name }
# end
#
module ActiveResourceSchema

	@@schema = []
	
	def initialize(attributes = {})
    	
    	# Loop through the schema and add any missing values into the attributes hash
    	for field in @@schema
    		attributes[field] = nil unless attributes.key?(field)
		end
    		
    	super(attributes)
    end
    
end