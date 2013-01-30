class GroupsViewController < UITableViewController

  GROUPS_URL = "http://community.davidbr-mbp.spiceworks.com/group.json"

  CELL_ID = "GROUP_CELL_ID"

  def init
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Groups", image: UIImage.imageNamed("groups.png"), tag:2)
    @recent_groups = []
    self
  end

  def viewDidLoad
    BW::HTTP.get(GROUPS_URL) do |res|
      @all_groups = BW::JSON.parse(res.body.to_str)
      @recent_groups = @all_groups[:recent_groups]
      self.tableView.reloadData
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @recent_groups.count rescue 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CELL_ID)
      cell
    end

    group = @recent_groups[indexPath.row]

    cell.textLabel.text = "#{group[:name]}"
    cell
  end
end
