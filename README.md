# UTApi

A thin api in ruby for ultimate team. It handles logging in, retrying requests, and http errors.
All the api calls (see below) return a hash which is just the json returned by that request
(I said it was thin).

## Installation

Add this line to your application's Gemfile:

    gem 'utapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install utapi

## Usage

```ruby
client = UTApi::Client.new(email, password, hash, platform)
client.login # true
client.credits

#  {
#    'credits' => 16659,
#    'currencies' => [
#        { 'name' => 'COINS', 'funds' => 16659, 'finalFunds' => 16659 },
#        { 'name' => 'POINTS', 'funds' => 0, 'finalFunds' => 0 }
#    ],
#    'unopenedPacks' => {
#        'preOrderPacks' => 0,
#        'recoveredPacks' => 0
#    },
#    'bidTokens' => {}
#  }

```

### Api Methods

* search(params)
* auction_status(ids)
* bid(trade_id, value)
* list_item(item_id, start_price, bin_price, duration)
* move_card(item_id, pile)
* trade_pile
* watch_list
* unassigned_items
* delete_from_trade_pile(trade_id)
* delete_from_watch_list(trade_id1, trade_id2, ...)
* get_credits

If you need more adding, just open an issue.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
