require 'cuckoo_filter'
require 'benchmark'
require 'benchmark/ips'

def setup(cf)
  puts "Setting up for benchmarking..."
  1_000_000.times do |i|
    cf.insert(rand)
  end
  puts "Done."
end

def timing_benchmark(cf)
  puts "\n1 Million Random Lookups"
  Benchmark.bm(5) do |x|
    x.report do |times|
      1_000_000.times do
        cf.lookup(rand)
      end
    end
  end
end

def ips_benchmark(cf)
  Benchmark.ips do |x|
    x.config(warmup: 5)

    x.report('Iterations per second') do |times|
      cf.lookup(rand)
    end
  end
end

if __FILE__ == $0
  cf = CuckooFilter.make(size: 1_000_000, kicks: 500, bucket_size: 4)
  setup(cf)
  timing_benchmark(cf)
  puts
  ips_benchmark(cf)
end
