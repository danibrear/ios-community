class LoginViewController < UIViewController
  PADDING = 10
  def loadView
    super
    self.setModalPresentationStyle(UIModalPresentationPageSheet)
    self.setModalTransitionStyle(UIModalTransitionStyleCoverVertical)
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
      user = User.new(name:"David Brear", email:"davidbrear04@gmail.com", id:123)
      user.save
    end
    @submit_button.origin = [
    @password_field.origin.x + @password_field.frame.size.width - @submit_button.frame.size.width,
    @password_field.origin.y + @password_field.frame.size.height + PADDING]
    self.view.addSubview(@submit_button)

  end

  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    true
  end

  def cancel_pressed
    self.dismissModalViewControllerAnimated(true)
  end
end
