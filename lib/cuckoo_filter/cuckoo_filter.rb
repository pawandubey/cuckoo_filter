require 'fnv'

module CuckooFilter
  # A Cuckoo Filter is a probablisitic data structure, which is highly
  # useful for set-membership determination, i.e. finding out whether
  # a given element is present in a set, as fast as possible.
  #
  # Probablistic data structures sacrifise some amount of accuracy for the
  # sake of performance. A Cuckoo Filter, hence sacrifises accuracy in
  # determining whether an element is "absent" - so it is likely to return
  # some amount of false positives i.e. it will return "present" for some
  # items which aren't actually present.
  #
  # Another popular data structure used for set-membership queries is the
  # oft-mentioned Bloom-filter. Cuckoo Filter improves upon the performance of
  # Bloom Filters by using only 2 hashes and deciding to store only the fixed-length
  # fingerprint of the elements instead of the whole element. This provides not only
  # spatial and performance gains, but also gives Cuckoo Filters the ability to delete
  # an element - something conspicuously missing from Bloom Filters.
  class CuckooFilter
    attr_reader :size, :max_kicks, :bucket_size, :num_buckets, :filled

    # Creates a new Cuckoo Filter with the provided options
    #
    # the number of buckets is the quotient of the total elements and bucket size
    #
    # the total size and bucket sizes are adjusted to the next power of two
    # to support easy bitmasks instead of costly mod operations
    #
    # @param size [Integer] the number of elements the filter can handle
    # @param kicks [Integer] the max number of kicks to tolerate during insertion
    # @param bucket_size [Integer] the number of entries per bucket
    #
    # @return [CuckooFilter]
    def initialize(size: 1024, kicks: 500, bucket_size: 4)
      @size = next_power_of_two(size)
      @max_kicks = kicks
      @bucket_size = next_power_of_two(bucket_size)
      @num_buckets = @size / @bucket_size
      @filled = 0
      @buckets = Array.new(@num_buckets) { Bucket.new(@bucket_size) }
    end

    # Inserts an item into the filter, returning true on success
    # or false when the filter is either filled or the maximum number
    # of kicks allowed is exceeded
    #
    # @param item [String] the item to be inserted
    #
    # @return [Boolean] true if successful insertion, else false
    def insert(item)
      fingerprint = fingerprint(item)
      first_index = hash(item)
      second_index = alt_index(first_index, fingerprint)

      if @buckets[first_index].insert(fingerprint) || @buckets[second_index].insert(fingerprint)
        increment_filled_count
        return true
      end

      index = [first_index, second_index].sample

      @max_kicks.times do
        fingerprint = @buckets[index].random_swap(fingerprint)
        index = alt_index(index, fingerprint)

        if @buckets[index].insert(fingerprint)
          increment_filled_count
          return true
        end
      end

      return false
    end

    # Tells whether the given item is present in the filter
    # with some statistical variance in accuracy - hence the term
    # "probablisitic data structure".
    # It has some amount of chance of returning a false positive
    #
    # @param item [String] the item to lookup in the filter
    #
    # @return [Boolean] true if present else false
    def lookup(item)
      fingerprint = fingerprint(item)
      first_index = hash(item)
      second_index = alt_index(first_index, fingerprint)

      @buckets[first_index].contains?(fingerprint) ||  @buckets[second_index].contains?(fingerprint)
    end

    # Delete the item from the filter if present
    #
    # @param item [String] the element to remove from the filter
    #
    # @return [Boolean] true if deletion successful else false
    def delete(item)
      fingerprint = fingerprint(item)
      first_index = hash(item)
      second_index = alt_index(first_index, fingerprint)

      if @buckets[first_index].remove(fingerprint) ||  @buckets[second_index].remove(fingerprint)
        decrement_filled_count
        return true
      end

      return false
    end

    private

    def next_power_of_two(num)
      if (num & (num - 1)) == 0
        [num, 1].max
      else
        1 << num.bit_length
      end
    end

    def fingerprint(item)
      Fingerprint.new(item)
    end

    def hash(item)
      h = Fnv::Hash.fnv_1a(item, size: 32)
      h & size_mask
    end

    def alt_index(first_index, fingerprint)
      i = first_index ^ hash(fingerprint)
      i & size_mask
    end

    def increment_filled_count
      @filled = [@filled.succ, @size].min
    end

    def decrement_filled_count
      @filled = [@filled.pred, 0].max
    end

    def size_mask
      ((1 << Math.log2(@num_buckets).to_i) - 1)
    end
  end
end
