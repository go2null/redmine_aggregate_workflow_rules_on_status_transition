
Redmine::Plugin.register :redmine_block_issue_updates_when_closed do
	name 'Block all issue updates when issue is closed'
	description 'Disallows updating issue fields when the issue is locked - allows moving between statuses with different field requirements'
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

