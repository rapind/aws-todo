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
    	
    	init_attribs = @@defaults
		#puts 'Attribs passed: ' + attributes.to_a.join("|")
		# This is annoying, but we need to remove default values manually by converting the keys
		# to strings and then checking for a match, because the hash merge function messes it up.
		for new_key in attributes.keys
			init_attribs.delete_if {|key, value| key.to_s == new_key.to_s }
		end
		init_attribs.merge!(attributes)
    	#puts 'Merged: ' + init_attribs.to_a.join("|")
    	
    	# call the super's init
    	super init_attribs
    	
    end
    
    
end