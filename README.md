[![Build Status](https://travis-ci.com/pawandubey/cuckoo_filter.svg?token=3cAzkSrcDxPpHpxsqQyX&branch=master)](https://travis-ci.com/pawandubey/cuckoo_filter) [![codecov](https://codecov.io/gh/pawandubey/cuckoo_filter/branch/master/graph/badge.svg)](https://codecov.io/gh/pawandubey/cuckoo_filter)


# CuckooFilter

Pure Ruby implementation of the [Cuckoo Filter](https://www.cs.cmu.edu/~dga/papers/cuckoo-conext2014.pdf) - a probabilistic datastructure which is objectively better than Bloom Filters for set-membership queries.

## What the heck is a Cuckoo Filter?

It is a probabilistic data structure which is used to determine set-membership, i.e. finding out if a given element exists in a given set.

For practical uses think - checking if an item is present in a cache, if it is present in a database or YouTube trying to figure out if you have already watched some video before it is recommended to you.

It is closely related to Bloom Filters - but outshines them in performance and space efficiency. You can read more from the [original paper](https://www.cs.cmu.edu/~dga/papers/cuckoo-conext2014.pdf) that introduced it in 2014. Yes, it is that young!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cuckoo_filter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cuckoo_filter

## Usage

```ruby
# Create a filter with 1024 (next power of 2) slots with each bucket holding 4
cf = CuckooFilter.make(size: 1000, kicks: 500, bucket_size: 4)
# => returns a CuckooFilter::CuckooFilter instance

# Insert an element into the filter
cf.insert("foo")
# => true

# Lookup the existence of an element
cf.lookup("foo")
# => true

cf.lookup("bar")
# => false

# Delete an existing element
cf.delete("foo")
# => true
```

## Frequenty Anticipated Questions

- Q: *Is this useful?*
  A: Yes, but mainly for academic purposes.
  
- Q: *Why not for practical purposes?*
  A: Because Ruby is not a performance-oriented language. It is made to be expressive, so it lacks a lot of low-level constructs needed to make this implementation fast and efficient enough.
  
- Q: *Then why did you make this?*
  A: For fun and education, of course!
  
- Q: *But why Ruby? Why not Go/Rust/Elixir/FooBar*
  A: Because why not? I like Ruby and I couldn't find a full blown implementation in it.
  
- Q: *Can I use it in a real project?*
  A: If it satisfies your criteria, then why not? Let me know if you do!
  
## Benchmarks

You can run the benchmark script to see both the duration it takes for a million random lookups as well as to see the iterations per second performance.

```
$ ruby test/benchmark.rb

Setting up for benchmarking...
Done.

1 Million Random Lookups
            user     system      total        real
       26.700000   0.030000  26.730000 ( 26.792196)

Warming up --------------------------------------
Iterations per second
                         3.828k i/100ms
Calculating -------------------------------------
Iterations per second
                        160.203M (±15.2%) i/s -    747.019M in   4.865628s

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pawandubey/cuckoo_filter.

## License

Copyright 2017 Pawan Dubey

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
