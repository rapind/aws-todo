# This module can be included in ActiveResource model classes to initialize attributes to default values
# like nil etc. so they work with view forms.
#
# You just need to define a @@defaults hash for the attributes in the including class.
#
# For example if you have a project class that always has 'first_name' and 'last_name' attributes 
# you can add it to the defaults so that calls to Project.new.first_name and Project.new.last_name 
# return nil instead of method not found exceptions.
#
# class Project < ActiveResource::Base
#   include ActiveResourceInit
#   @@defaults = {:first_name => nil, :last_name => nil}
# end
#
module ActiveResourceSchema

	@@defaults = {}
	
	def initialize(attributes = {})
    	
    	@@defaults.merge!(attributes) unless attributes.empty?
    	super @@defaults
    	
    end
    
end