# Va

Va is a minimalistic validation library.

It is meant to be used as a first line of defense from external imputs.

Va doesnn't care what framework you're using, it just provides a good way to set and validate attributes in a model.

## Usage

### Attributes

Say you need a signup form validator that only allows an email, a password and the password confirmation.
The first thing to do is to create the corresponding model

```ruby
  class Signup < Va::Model
    attribute :email
    attribute :password
    attribute :password_confirmation
  end
```

And then you can instantiate it like this:

```ruby
  s = Signup.new(email: "fede@example.com", password: "123456", password_confirmation: "123456")
  # => #<Signup:0x00000001cc90d8
  #     @attributes=
  #      {:email=>"fede@example.com",
  #       :password=>"123456",
  #       :password_confirmation=>"123456"}>
```

As you can see, you can use either Strings or Symbols as keys (to be fair, it allows any object that responds to the `#to_sym` method)

You can check the values of the attributes using the `#attributes` method.

```ruby
  s.attributes
  # => {:email=>"fede@example.com",
  #     :password=>"123456",
  #     :password_confirmation=>"123456"}
```

If you miss an argument, it won't appear on the attributes list:

```ruby
  s = Signup.new(email: "fede@example.com", "password_confirmation" => "123456")
  s.attributes
  # => {:email=>"fede@example.com",
  #     :password_confirmation=>"123456"}
```

And if you pass a non-declared attribute, it will be ignored:

```ruby
  s = Signup.new(email: "fede@example.com", phone_number: "987654321")
  # => #<Signup:0x000000015f8dd0 @attributes={:email=>"fede@example.com"}>
```

### Default Values

You can assign a default value for an attribute, in which case, if no value is provided, it will get assigned either way:

```ruby
  class UserValidator < Va::Model
    attribute :name, default: "N/A"
    attribute :admin,  default: false
    attribute :editor, default: true
    attribute :remember_me, default: true
    attribute :age
    attribute :height
  end
  
  u = UserValidator.new(age: 30, remember_me: false)
  u.attributes
  # => {:name=>"N/A",
  #     :admin=>false,
  #     :editor=>true,
  #     :remember_me=>false,
  #     :age=>30}
```

Note that `age` and `remember_me` were set explicitly, `name`, `admin` and `editor` where set by default, and `height wasn't set at all.

### Custom Validations


Up until here, we haven't talked about validations.

Va allows you to write generic validations.

For example, if we need the email to be present and the password and password validation to match, we can do it as it follows:

```ruby
  s = Signup.new(email: "fede@example.com", password: "a", password_confirmation: "a")
  s.valid?
  # => true
  
  t = Signup.new(password: "a", password_confirmation: "a")
  t.valid?
  # => false
  
  u = Signup.new(email: "fede@example.com", password: "a", password_confirmation: "b")
  u.valid?
  # => false
```

### Predefined Validations

#### Blank

If you want to validate that a field is not blank, you can just say:

```ruby
  class Person < Va::Model
    attribute :name
    attribute :age
    validate_present(:name, :age)
  end
```

And if any of those attributes is either nil or an empty string, the validation will fail.

#### More Validations

TODO: Add more validations

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'va'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install va


## Contributing

1. Fork it ( https://github.com/[my-github-username]/va/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
