include RbCommonHelper
include ProjectsHelper

class RbProjectSettingsController < RbApplicationController
  unloadable

  def project_settings
    if Setting.respond_to? :plugin_redmine_project_issue_statuses
      if(params[:status] != nil && params[:status] != "")
        issue_status = IssueStatus.new()
        issue_status.name = params[:status]
        if Setting.plugin_redmine_project_issue_statuses == nil || Setting.plugin_redmine_project_issue_statuses == ""
          Setting.plugin_redmine_project_issue_statuses = {'issueStatusToProject' => {}}
        end
        if Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'] == nil || Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'] == ""
          Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'] = {}
        end
        if issue_status.save
          Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'].merge!({issue_status.id => [@project.id]})
          setting = Setting.find_or_default("plugin_redmine_project_issue_statuses")
          setting.value = Setting.plugin_redmine_project_issue_statuses
          setting.save
          #https://www.redmine.org/issues/9226 by Jan from Planio/Yehuda Katz, updated for the newest version of Redmine by Summer Softleigh.
          begin
            WorkflowTransition.transaction do
              Tracker.all.each do |tracker|
                Role.all.each do |role|
                  (IssueStatus.all - [issue_status]).each do |status|
                    WorkflowTransition.create! :tracker_id => tracker.id, :old_status => issue_status, :new_status => status, :role => role # from
                    WorkflowTransition.create! :tracker_id => tracker.id, :old_status => status, :new_status => issue_status, :role => role # to
                  end
                  WorkflowTransition.create! :tracker_id => tracker.id, :old_status => issue_status, :new_status => issue_status, :role => role # self-to-self
                end
              end
            end
            flash[:success] = 'Added new issue status.'
          rescue
            flash[:warning] = 'Unable to add issue status to all workflows.'
          end
        else
          issue_status = IssueStatus.find_by(name: params[:status])
          if(params[:status] != "Backlog" && issue_status != nil && Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'].has_key?(issue_status.id))
            if(!Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'][issue_status.id].respond_to?('include?'))
              Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'][issue_status.id] = [Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'][issue_status.id]]
            end
            if (!Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'][issue_status.id].include?(@project.id))
              Setting.plugin_redmine_project_issue_statuses['issueStatusToProject'][issue_status.id] << @project.id
            end
            flash[:success] = 'Updated project issue status.'
          else
            flash[:error] = 'Unable to add issue status.  Maybe the name is invalid or already exists as a global issue status?'
          end
        end
      end
    end
    enabled = false
    enabled_scrum_stats = false
    if request.post? and params[:settings]
      enabled = true if params[:settings]["show_stories_from_subprojects"]=="enabled"
      enabled_scrum_stats = true if params[:settings]["show_in_scrum_stats"]=="enabled"
    end
    settings = @project.rb_project_settings
    settings.show_stories_from_subprojects = enabled
    settings.show_in_scrum_stats = enabled_scrum_stats
    if settings.save
      flash[:notice] = t(:rb_project_settings_updated)
    else
      flash[:error] = t(:rb_project_settings_update_error)
    end
    redirect_to :controller => 'projects', :action => 'settings', :id => @project,
                :tab => 'backlogs'
  end

end
