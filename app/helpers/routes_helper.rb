module RoutesHelper

  def community_domain
    #"http://community.davidbr-mbp.spiceworks.com"
    "http://10.10.49.30"
  end

  #PATHS
  def login_path
    community_domain + "/api/login.json"
  end
  def channel_url
    community_domain + "/api/channels"
  end
  def topic_path(id)
    community_domain + "/api/topics/#{id}.json"
  end

  def messages_index_path
    community_domain + "/api/messages/inbox.json"
  end
  
  def message_path(id)
    community_domain + "/api/messages/show.json?id=#{id}"
  end

  def spice_path
    community_domain + "/ranking/rank"
  end

  def channel_topics_path(channel_id)
    community_domain + "/api/channels/#{channel_id}/topics"
  end
  def channel_show_path(id)
    community_domain + "/api/channels/#{id}.json"
  end
end
