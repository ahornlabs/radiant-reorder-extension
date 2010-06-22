module Reorder::PagesControllerExtensions

  %w{move_higher move_lower move_to_top move_to_bottom}.each do |action|
    define_method action do
      @page = Page.find(params[:id])
      @page.parent.reload.children.reload
      old_position = @page.position
      @page.send(action)
      clear_cache if @page.position != old_position
      response_for :update
    end
  end
  
  private 
  
  def clear_cache
    if defined? ResponseCache == 'constant'
      ResponseCache.instance.clear
    else
      Radiant::Cache.clear
    end
  end
  
end
