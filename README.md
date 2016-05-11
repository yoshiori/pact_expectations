[![Build Status](https://travis-ci.org/yoshiori/pact_expectations.svg?branch=master)](https://travis-ci.org/yoshiori/pact_expectations)

# PactExpectations

Pact response convert to stub.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pact_expectations'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pact_expectations

## Usage

for example

```ruby
class APIClient
  def item(id)
    # Sending api request
  end
end

PactExpectations.add_response_body_for(
  "a request for an item",
  Pact.like(
    id: 1,
    name: "pen",
  ),
)

## CDC testing with Pact
describe APIClient, pact: true do
  describe "#item" do
      before do
        api
          .given("an item exists")
          .upon_receiving("a request for an item")
          .with(method: :get, path: "/item/1")
          .will_respond_with(
            status: 200,
            body: PactExpectations.response_body_for("a request for an item"),
          )
      end
      it { expect(APIClient.item(1).name).to eq "pen" }
    end
  end
end

## Stub Remote Facade's method
describe ItemsController do
  describe "show" do
    before do
      allow(APIClient).to(
        receive(:item).with(1).and_return(PactExpectations.reified_body_for("a request for an item"))
      )
    end
    it do
      get :show, id: 1
      expect(assigns[:item].name).to eq "pen"
    end
  end
end
```

### Verify expectation was called.

```ruby
RSpec.configure do |config|
  config.after(:suite) do
    PactExpectations.verify if ENV["PACT_VERIFY_EXPECTATIONS"] == "1"
  end
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshiori/pact_expectations.

## Special Thanks
[Taiki Ono](https://github.com/taiki45) gave me a lot of advice.
