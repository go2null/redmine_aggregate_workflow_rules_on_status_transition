
Redmine::Plugin.register :redmine_aggregate_workflow_rules_on_status_transition do
	name 'Aggregate Workflow Rules Plugin'
	description 'Plugin to aggregate workflow rules between status transitions'
	url ''

	author 'farkwun'
	author_url 'https://github.com/farkwun'

	version '0.1'
	requires_redmine :version_or_higher => '2.0.0'
end


# As per http://www.redmine.org/projects/redmine/wiki/Plugin_Internals
# Due to the redmine loading lifecyle, plugin objects are loaded before
# the Redmine objects are loaded. Thus, we have to monkeypatch instead of
# merely opening up the class.
#
# Examples place these patches inside /lib but I find /app/models to be
# a more natural place for them.
#
def load_patches(path = nil)
	begin
		Project.columns
	rescue ActiveRecord::StatementInvalid => e
		# the database hasn't been populated yet,
		# we're probably undergoing a migration.
		puts "Not loading patches."
		return
	end
	directory ||= File.dirname(__FILE__)
	dir_paths = ["app/models/**", "app/helpers"]
	dir_paths.each do |dir_path|
		Dir.glob(File.join(directory, dir_path, '*.rb')).each do |file|
			load file
		end
	end
end
load_patches

