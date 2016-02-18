module IssuePatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		# Wrap the methods we are extending
		base.alias_method_chain :safe_attribute_names, :block_closed_item_fields

		# Exectue this code at the class level (not instance level)
	end

	module InstanceMethods
			
		def safe_attribute_names_with_block_closed_item_fields(user=nil)
			names = safe_attribute_names_without_block_closed_item_fields(user)				
			if was_closed?
				names = 'status_id' 
				if status_id_changed? && !status.is_closed?
					names = safe_attribute_names_without_block_closed_item_fields(user)			
				end
			end
			names

		end
	end
end

Issue.send :include, IssuePatch
