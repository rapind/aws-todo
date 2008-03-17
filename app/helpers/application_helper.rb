# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	def show_flash
		[:notice, :warning, :message].collect do |key|
			content_tag(:div, flash[key], :class => "flash_banner") unless flash[key].blank?
		end.join
	end
  
	# from Dan Webb's MinusMOR plugin
	def js(data)
	  if data.respond_to? :to_json
	    data.to_json
	  else
	    data.inspect.to_json
	  end
	end

	# from Dan Webb's MinusMOR plugin
	# enhanced with ability to detect partials with template format, i.e.: _post.html.erb
	def partial(name, options={})
	  old_format = self.template_format
	  self.template_format = :html
	  js render({ :partial => name }.merge(options))
	ensure
	  self.template_format = old_format
	end
	
	def selector(obj)
	  js "##{dom_id(obj)}"
	end

end
