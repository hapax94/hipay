# Hipay

Provide Cash Out and TPP integration client

## Installation

Add this line to your application's Gemfile:

    gem 'hipay'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hipay

## Usage

```ruby
client = Hipay::Client.new wsdl: "https://#{base_url}/soap/user-account-v2?wsdl",
   wsLogin: "my_login",
   wsPassword: "my_password",
   entity: "my_entity"

client.call :is_available, email: 'nicolas.papon@gmail.com'
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hipay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request