class MessagesIndexController < ApplicationController

  UNREAD_CELL_ID = "unread_cell_id"
  READ_CELL_ID = "read_cell_id"

  def viewDidLoad
    super
    self.title = "Messages"
    home_image = UIImage.imageNamed "home_white.png"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(home_image, style:UIBarButtonItemStyleBordered, target:self, action:'home_pressed')
    load_messages
  end
  def home_pressed
    self.navigationController.popToRootViewControllerAnimated(true)
  end
  def load_messages
    BubbleWrap::HTTP.get(messages_index_path, headers: current_user_headers) do |response|
      if response.ok?
        @data = BubbleWrap::JSON.parse(response.body.to_str)
        @messages = @data[:messages]
        fill_table
      else
        alert = UIAlertView.alloc.initWithTitle("Failed to Load Messages", message:"There was an error loading the messages", delegate:self, cancelButtonTitle:"That Sucks", otherButtonTitles:nil)
        alert.show
      end
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @messages.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = nil
    id = UNREAD_CELL_ID
    unread = @messages[indexPath.row][:unread]
    if unread
      cell = tableView.dequeueReusableCellWithIdentifier(UNREAD_CELL_ID)
    else
      cell = tableView.dequeueReusableCellWithIdentifier(READ_CELL_ID)
      id = READ_CELL_ID
    end
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:id)

    if unread
      cell.contentView.backgroundColor = "#fff6f2".to_color
      cell.imageView.image = UIImage.imageNamed "new_mail.png"
    end
    subject = @messages[indexPath.row][:subject]

    cell.textLabel.text = subject
    cell.textLabel.backgroundColor = UIColor.clearColor
    cell.textLabel.font = UIFont.boldSystemFontOfSize(NORMAL_FONT)
    cell.detailTextLabel.text = @messages[indexPath.row][:text]
    cell.detailTextLabel.backgroundColor = UIColor.clearColor
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    message_id = @messages[indexPath.row][:id]
    message_controller = MessageController.alloc.initWithId(message_id)
    self.navigationController.pushViewController(message_controller, animated:true)
  end

  def fill_table
    @messages_holder = UITableView.alloc.initWithFrame(self.view.bounds)
    @messages_holder.delegate = @messages_holder.dataSource = self

    self.view.addSubview(@messages_holder)
  end
end
