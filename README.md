# BrokerageTools

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'brokerage_tools'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brokerage_tools

## Usage

#### If installed as a gem run with:

    brokerage-tools -p trdrevtd --no-records --no-backup --no-trailer
    brokerage-tools -p trdrevtd

    # unzip and parse any files found    
    brokerage-tools -p bbc710z --include-zips

#### During development run with:

    ruby -Ilib bin/brokerage-tools -p trdrevtd --no-records --no-backup --no-trailer
    ruby -Ilib bin/brokerage-tools -p trdrevtd
    ruby -Ilib bin/brokerage-tools -p bbc710z --include-zips

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Building the gem from master
    $ gem uninstall -aix brokerage_tools
    $ git clone https://github.com/brokerage-management-systems/brokerage-tools
    $ cd brokerage_tools
    $ rake build
    $ gem install pkg/brokerage_tools*.gem

