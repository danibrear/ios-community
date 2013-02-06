class LoginViewController < UIViewController
  include RoutesHelper
  PADDING = 10

  def loadView
    super
    self.setModalPresentationStyle(UIModalPresentationPageSheet)
    self.setModalTransitionStyle(UIModalTransitionStyleCoverVertical)
  end

  def set_container(controller)
    @container_controller = controller
  end

  def viewDidLoad
    super

    self.title = "Login"
    self.view.backgroundColor = UIColor.whiteColor
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Cancel", style:UIBarButtonItemStyleBordered, target:self, action: 'cancel_pressed')

    @email_field = UITextField.alloc.initWithFrame([[0,0],[self.view.frame.size.width-PADDING*4, 26]])
    @email_field.placeholder = "Email"
    @email_field.borderStyle = UITextBorderStyleRoundedRect

    @email_field.delegate = self
    @email_field.returnKeyType = UIReturnKeyDone
    @email_field.autocapitalizationType = UITextAutocapitalizationTypeNone
    @email_field.center = [
      self.view.frame.size.width/2,
      @email_field.center.y + PADDING]

    self.view.addSubview(@email_field)

    @password_field = UITextField.alloc.initWithFrame([[0,0],@email_field.frame.size])
    @password_field.borderStyle = UITextBorderStyleRoundedRect
    @password_field.secureTextEntry = true
    @password_field.center = [
      @email_field.center.x,
      @email_field.center.y + @email_field.frame.size.height + PADDING]

    @password_field.placeholder = "Password"

    self.view.addSubview(@password_field)

    @submit_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @submit_button.setTitle("Login", forState:UIControlStateNormal)
    @submit_button.setTitle("Loading...", forState:UIControlStateDisabled)
    @submit_button.sizeToFit

    @submit_button.when(UIControlEventTouchUpInside) do
      @password = @password_field.text
      @email = @email_field.text
      BubbleWrap::HTTP.post(login_path, payload:{login:{email:@email, password:@password}}) do |response|

        if response.ok?
          user = create_user_from_response(response)
          user.save
          @container_controller.reset_view
          cancel_pressed
        else
          @alert = UIAlertView.alloc.initWithTitle("Response was bad", message:"#{response.body.to_str}", delegate:nil, cancelButtonTitle: "Ok", otherButtonTitles: nil)
          @alert.show
        end
      end
    end
    @submit_button.origin = [
    @password_field.origin.x + @password_field.frame.size.width - @submit_button.frame.size.width,
    @password_field.origin.y + @password_field.frame.size.height + PADDING]
    self.view.addSubview(@submit_button)

  end

  def parse_cookie(cookie_str)
    parts = cookie_str.match(/=(.+);/)[1] rescue ""
  end

  def create_user_from_response(response)
    response_json = BubbleWrap::JSON.parse(response.body.to_str)
    cookie = parse_cookie(response.headers["Set-Cookie"])
    user = User.new(name:   response_json["name"],
                    email:  response_json["email"],
                    id:     response_json["id"],
                    session:cookie)
  end

  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    true
  end

  def cancel_pressed
    self.dismissModalViewControllerAnimated(true)
  end
end
