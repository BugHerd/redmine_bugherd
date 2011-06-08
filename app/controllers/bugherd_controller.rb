class BugherdController < ApplicationController
  unloadable
  before_filter :require_admin

  BUGHERD_PRIORITIES = {
    0 => '-',
    1 => 'Critical',
    2 => 'Important',
    3 => 'Normal',
    4 => 'Minor',
  }

  BUGHERD_PRIORITY_MAP = {
    1 => 'Urgent',
    2 => 'High',
    3 => 'Normal',
    4 => 'Low',
  }

  BUGHERD_STATUSES = {
    0 => 'Backlog',
    1 => 'To do',
    2 => 'In progress',
    4 => 'Testing',
    5 => 'Archive',
  }

  BUGHERD_STATUS_MAP = {
    0 => 'New',
    1 => 'New',
    2 => 'New',
    4 => 'Resolved',
    5 => 'Closed',
  }

  def update
    @project = Project.find(params[:project_id])
    if params[:id].present?
      @issue = @project.issues.find(params[:id])
    else
      @issue = @project.issues.new
      @issue.tracker = Tracker.find_by_name('Bug')
    end
    
    @issue.subject = params[:description] if params[:description]
    @issue.status = best_match_status(params[:status_id]) if params[:status_id]
    @issue.priority = best_match_status(params[:priority_id]) if params[:priority_id]
    
    @issue.save
    
    render :text => "OK #{@issue.id}"
  end
  
  def add_comment
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @issue.journals.create(:notes => params[:comment])
  end
  
private

  def best_match_status(status_id)
    IssueStatus.find_by_name(BUGHERD_STATUS_MAP[status_id])
  end

  def best_match_priority(priority_id)
    IssuePriority.find_by_name(BUGHERD_PRIORITY_MAP[priority_id])
  end
  
end
