require 'cuckoo_filter'
require 'benchmark'
require 'benchmark/ips'

def setup(cf)
  puts "Setting up for benchmarking..."

  500_000.times do |i|
    cf.insert(rand(100_000_000))
  end

  puts "Done."
end

def ips_benchmark(cf)
  Benchmark.ips do |x|
    x.config(warmup: 5, time: 10)

    x.report('Iterations per second - Insertions') do |times|
      cf.insert(rand(100_000_000))
    end

    x.report('Iterations per second - Lookups') do |times|
      cf.lookup(rand(100_000_000))
    end

    x.report('Iterations per second - Deletions') do |times|
      cf.delete(rand(100_000_000))
    end
  end
end

if __FILE__ == $0
  cf = CuckooFilter.make(size: 1_000_000, kicks: 500, bucket_size: 4)
  setup(cf)
  ips_benchmark(cf)
end
