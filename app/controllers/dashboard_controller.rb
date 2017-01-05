class DashboardController < ApplicationController
  before_filter :set_selected_tab
	layout "app"

  def index
    widgets = current_user.sports || []

    table_data = {}

    @unit_name = current_user.units.first.name

    @widgets = {
      :list_data => widgets,
      # :activity_split => activity_split,
      :table_data => {
          :Swimming => Activities.swimming(current_user.id, @unit_name),
          :Cycling => Activities.cycling(current_user.id, @unit_name),
          :Running => Activities.running(current_user.id, @unit_name),
          :Other => Activities.other(current_user.id, @unit_name)
      }
    }.to_json

    @sports = Sports.all.to_json
  end
  
  def add_widget
    current_user.update(:widget_config => params[:widgets])
    
    render :json => {:success => true}
  end

  def set_selected_tab
    @selected_tab = :dashboard
  end

  private 

    def activity_split
      total = Activities.where(user_id: current_user.id).all.count.to_f
      swimming = Activities.where(user_id: current_user.id, sports_id: Activities::SWIMMING).all.count
      cycling = Activities.where(user_id: current_user.id, sports_id: Activities::CYCLING).all.count
      running = Activities.where(user_id: current_user.id, sports_id: Activities::RUNNING).all.count
      other = Activities.where(user_id: current_user.id, sports_id: Activities::OTHER).all.count
      {
        Swimming: ((swimming/total) * 100).round(2),
        Cycling:  ((cycling/total) * 100).round(2),
        Running:  ((running/total) * 100).round(2),
        Other:  ((other/total) * 100).round(2),
      }
    end
end