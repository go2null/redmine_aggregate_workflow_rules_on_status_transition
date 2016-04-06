module IssuePatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		# Wrap the methods we are extending
		base.alias_method_chain :safe_attribute_names, :removed_closed_item_fields

		# Exectue this code at the class level (not instance level)
	end

	module InstanceMethods
			
		def safe_attribute_names_with_removed_closed_item_fields(user=nil)
			if status_was.is_closed? && !reopened?
				'status_id' 
			else
				safe_attribute_names_without_removed_closed_item_fields(user)
			end
		end
	end
end

Issue.send :include, IssuePatch
