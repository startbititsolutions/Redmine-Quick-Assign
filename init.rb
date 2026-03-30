require 'redmine'

Redmine::Plugin.register :redmine_quick_assign do
  name        'Redmine Quick Assign'
  author      'Startbit IT Solutions'
  author_url  'https://startbitsolutions.com/'
  description 'Adds quick assignment actions for Author, Last Commenter, and Previous Assignee on issue show, edit, and context menu.'
  version     '1.0.0'
  requires_redmine version_or_higher: '5.1.0'
end

# to_prepare runs after Rails/Redmine fully boots and again on every code reload
# in development. The include? guard prevents double-patching across reloads.
Rails.configuration.to_prepare do
  require_dependency 'issues_controller'
  require_relative 'lib/redmine_quick_assign/hooks'
  require_relative 'lib/redmine_quick_assign/patches/issues_controller_patch'

  unless IssuesController.included_modules.include?(RedmineQuickAssign::Patches::IssuesControllerPatch)
    IssuesController.send(:include, RedmineQuickAssign::Patches::IssuesControllerPatch)
  end
end
