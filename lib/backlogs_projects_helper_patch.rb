require_dependency 'projects_helper'

module Backlogs
  module ProjectsHelperPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :project_settings_tabs, :backlogs
      end
    end

    module InstanceMethods

      def project_settings_tabs_with_backlogs
        tabs = project_settings_tabs_without_backlogs
        tabs << {:name => 'backlogs',
          :action => :manage_project_backlogs,
          :partial => 'backlogs/project_settings',
          :label => :label_backlogs
        } if @project.module_enabled?('backlogs') and 
             User.current.allowed_to?(:configure_backlogs, nil, :global=>true)
=begin
          if(Setting.respond_to? :plugin_redmine_project_issue_statuses) %>
            if Setting.plugin_redmine_project_issue_statuses == nil || Setting.plugin_redmine_project_issue_statuses == ""
              Setting.plugin_redmine_project_issue_statuses = {'issueStatusToProject' => {}}
            end
            if Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'] == nil || Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'] == ""
              Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'] = {}
            end
            tabs << {:name => 'backlogs',
                     :action => :manage_project_backlogs,
                     :partial => 'backlogs/project_settings',
                     :label => :label_backlogs
            }
          end
=end
          return tabs
      end

    end

  end
end

ProjectsHelper.send(:include, Backlogs::ProjectsHelperPatch) unless ProjectsHelper.included_modules.include? Backlogs::ProjectsHelperPatch

