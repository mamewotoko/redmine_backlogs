require_dependency 'user'

module Backlogs
  module IssueStatusPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
    end

    module InstanceMethods

      def new_statuses_allowed_to_with_new_statuses_allowed_to_system
        allowed_statuses = new_statuses_allowed_to_without_new_statuses_allowed_to_system
        if(Setting.respond_to? :plugin_redmine_project_issue_statuses)
          if Setting.plugin_redmine_project_issue_statuses == nil || Setting.plugin_redmine_project_issue_statuses == ""
            Setting.plugin_redmine_project_issue_statuses = {'issueStatusToProject' => {}}
          end
          if Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'] == nil || Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'] == ""
            Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'] = {}
          end
          allowed_statuses.delete_if { |status| (status.name == "Backlog" || Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'].has_key?(status.id)) }
        end
        return allowed_statuses
      end

      def backlog(tracker=nil)
        unless tracker
          Rails.logger.warn("IssueStatus.backlog called without parameter")
          begin 5 / 0; rescue => e; Rails.logger.warn e; Rails.logger.warn e.backtrace.join("\n"); end
        end
        if Redmine::VERSION::MAJOR >= 3 && tracker
          is_default = tracker.default_status_id == id
        else
          is_default = is_default?
        end
        return :success if is_closed? && (default_done_ratio.nil? || default_done_ratio == 100)
        return :failure if is_closed?
        return :new if is_default || default_done_ratio == 0
        return :in_progress
      end

      def backlog_is?(states, tracker=nil)
        states = [states] unless states.is_a?(Array)
        raise "Not a valid state set #{states.inspect}" unless (states - [:success, :failure, :new, :in_progress]) == []
        return states.include?(backlog(tracker))
      end
    end
  end
end

IssueStatus.send(:include, Backlogs::IssueStatusPatch) unless IssueStatus.included_modules.include? Backlogs::IssueStatusPatch
