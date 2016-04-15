module IssuePatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		# Wrap the methods we are extending
		base.alias_method_chain :workflow_rule_by_attribute, :aggregate_workflows

		# Exectue this code at the class level (not instance level)
	end

	module InstanceMethods
			
	  	# aggregates/ORs workflows so that switching to a status with  
	 	# read_only fields (that should be filled once in a read-only status)
	  	# changes them to required **during the change only** 
		def workflow_rule_by_attribute_with_aggregate_workflows(user=nil)

		 # change the status_id to the old status so as not to have to 
		 # change the innards fo the workflow_rule_by_attribute method.
		  
		 # Storing result_was first is because the @workflow_rule_by_attribute
		 # instance variable is set in the without method - in order to avoid
		 # having to set the instance variable at the end of this method, 
		 # having the order in this way sets the instance variable as originally
		 # intended
		 status_temp = self.status_id
		 self.status_id = status_id_was

		 # store the result
	     result_was = workflow_rule_by_attribute_without_aggregate_workflows(user)

		 # switch back to the current status
		 self.status_id = status_temp
		 result_is = workflow_rule_by_attribute_without_aggregate_workflows(user)

		 result = result_is
		 # normal behaviour if the two hashes are the same (in other words, 
		 # the issue is not undergoing a meaningful status transition) 
		 unless result_is == result_was
		   # for every value that is read_only in the current status 
		   # but is not read_only in the previous one,
		   # set to required instead
		   result_is.each do |k, v|
			 if v == 'readonly' && result_was[k] != 'readonly'
			   result[k] = 'required'
			 end
		   end
		 end
		 result
		end
	end
end

Issue.send :include, IssuePatch
