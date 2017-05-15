require "cuckoo_filter/version"
require "cuckoo_filter/fingerprint"
require "cuckoo_filter/bucket"
require "cuckoo_filter/cuckoo_filter"
require "cuckoo_filter/cuckoo_filter_error"

# @see CuckooFilter::CuckooFilter for documentation
module CuckooFilter
  # Create and return a new {CuckooFilter} instance
  def self.make(size: 1024, kicks: 500, bucket_size: 4)
    CuckooFilter.new(size: size, kicks: kicks, bucket_size: bucket_size)
  end
end
