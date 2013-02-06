module RoutesHelper

  def community_domain
    "http://community.davidbr-mbp.spiceworks.com"
  end

  #PATHS
  def login_path
    community_domain + "/api/login.json"
  end
  def channel_url
    community_domain + "/api/channels/index.json"
  end
  def topic_path(id)
    community_domain + "/api/topic/#{id}.json"
  end
  def channel_show_path(id)
    community_domain + "/api/channels/show.json?id=#{id}"
  end
end
