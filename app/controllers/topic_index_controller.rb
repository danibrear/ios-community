class TopicIndexController < ApplicationController

  CELL_ID = "CELL_ID"

  attr_accessor :channel_id

  def initWithChannelId(cid)
    initWithNibName(nil, bundle:nil)
    @channel_id = cid
    BubbleWrap::HTTP.get(channel_topics_path(cid)) do |response|
      if response.ok?
        @data = BubbleWrap::JSON.parse(response.body.to_str)
        init_topics_tables
      else
        alert = UIAlertView.alloc.initWithTitle("Error Loading Topics", message:"There was an error loading the topics", delegate:self, cancelButtonTitle:"That sucks", otherButtonTitles:nil)
        alert.show
      end
    end
    self
  end

  def init_topics_tables
    tableView = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStyleGrouped)

    tableView.delegate = tableView.dataSource = self
    self.view.addSubview(tableView)
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @data.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID)
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: CELL_ID)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.textLabel.text = @data[indexPath.row][:subject].gsub(/(\n|\t)+/, " ")
    cell.detailTextLabel.text = @data[indexPath.row][:excerpt].gsub(/(\n|\t)+/, " ")
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    topic_id = @data[indexPath.row][:id]
    topic_controller = TopicController.alloc.initWithTopic(topic_id)
    self.navigationController.pushViewController(topic_controller, animated:true)
  end

  def viewDidLoad
    super
    self.title = "Topics"
  end
end
