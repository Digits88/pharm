class PhotoSweeper < ActionController::Caching::Sweeper
  observe Photo

  def before_create(photo)
    Photo.ordered.limited(2).selection(:id).each do |photo|
      expire_page(:controller => 'photos', :action => 'show', :id => photo)
    end
  end

  def after_create(photo)
    expire_page('/index.html')
    Photo.ordered('created_at ASC').limited(1).selection(:id).each do |photo|
      expire_page(:controller => 'photos', :action => 'show', :id => photo)
    end
  end

  def after_save(photo)
    expire_page('/index.html') if photo.id == Photo.ordered.limited(1).selection(:id).first.id
    expire_cache_for(photo)
  end
  
  def before_destroy(photo)
    photos = [] << photo.previous(circular=true) << photo.following
    Photo.ordered.limited(2).selection(:id).each do |photo|
      expire_page(:controller => 'photos', :action => 'show', :id => photo)
    end
  end
  
  def after_destroy(photo)
    expire_page('/index.html')
    expire_cache_for(photo)
  end
  
private

  def expire_cache_for(photo)
    expire_page(:controller => 'photos', :action => 'show', :id => photo.id)
  end
  
end