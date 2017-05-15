require 'fnv'

module CuckooFilter
  class CuckooFilter
    attr_reader :size, :max_kicks, :bucket_size, :num_buckets, :filled

    def initialize(size: 1024, kicks: 500, bucket_size: 4)
      @size = next_power_of_two(size)
      @max_kicks = kicks
      @bucket_size = next_power_of_two(bucket_size)
      @num_buckets = @size / @bucket_size
      @filled = 0
      @buckets = Array.new(@num_buckets) { Bucket.new(@bucket_size) }
    end

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

    def lookup(item)
      fingerprint = fingerprint(item)
      first_index = hash(item)
      second_index = alt_index(first_index, fingerprint)

      @buckets[first_index].contains?(fingerprint) ||  @buckets[second_index].contains?(fingerprint)
    end

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
