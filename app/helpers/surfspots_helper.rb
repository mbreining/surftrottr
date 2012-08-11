module SurfspotsHelper

  def find_states
    Surfspot.find_by_sql "SELECT DISTINCT s.state FROM surfspots s ORDER BY s.state"
  end
  
  def find_cities(state)
    Surfspot.find_by_sql "SELECT DISTINCT s.city FROM surfspots s WHERE s.state = '#{state}' ORDER BY s.city"
  end
  
  def find_surfspots(state, city)
    Surfspot.find_by_sql "SELECT s.id, s.name FROM surfspots s WHERE s.state = '#{state}' AND s.city = '#{city}' ORDER BY s.name"
  end

  def is_surfspot_favorite?(surfspot_id)
	favorites = current_user.favorites
	
	favorites.each do |favorite|
	  if favorite.surfspot_id == surfspot_id
        return true
	  end
	end
	
	return false
  end
  
end
