module CuckooFilter
  # A Bucket is essentially a collection of a finite number of
  # Fingerprints.
  #
  # Buckets are the actual storage unit in a Cuckoo Filter.
  class Bucket
    attr_reader :size, :slots

    def initialize(size)
      @size = size
      @filled = 0
      @slots = Array.new(@size) { Fingerprint.new }
    end

    # Inserts the given fingerprint into one of the slots
    # if a slot is found to be empty
    #
    # @param fingerprint [Fingerprint] the fingerprint to insert
    #
    # @return [Boolean] whether the insertion was successful
    def insert(fingerprint)
      @slots.each do |slot|
        if slot.empty?
          slot.set(fingerprint)
          @filled = [(@filled + 1), 4].min
          return true
        end
      end

      false
    end

    # Removes the given fingerprint from the bucket if present
    #
    # @param fingerprint [Fingerprint] the fingerprint to remove
    #
    # @return [Fingerprint, nil] the removed fingerprint if successful, else nil
    def remove(fingerprint)
      if contains?(fingerprint)
        @filled = [(@filled - 1), 0].max
        slot = @slots.find { |slot| slot.value == fingerprint.value }
        slot.clear!
      end
    end

    # Swaps the given fingerprint with a randomly selected one
    # already present in it, returning the replaced fingerprint
    #
    # This is used while "kicking" a fingerprint out during the
    # insertion process.
    #
    # @see CuckooFilter::CuckooFilter#insert
    #
    # @param fingerprint [Fingerprint] the fingerprint to swap into the bucket
    #
    # @return [Fingerprint] the fingerprint swapped out of the bucket
    def random_swap(fingerprint)
      random_index = rand(@size)
      fingerprint, @slots[random_index] = @slots[random_index], fingerprint
      fingerprint
    end

    # @return [Boolean] if the bucket contains the given fingerprint
    def contains?(fingerprint)
      @slots.any? { |slot| slot.value == fingerprint.value }
    end

    # Clears all the values of the fingerprints
    def clear!
      @slots.map(&:clear!)
      @filled = 0
    end

    # @return [Boolean] true if the bucket has an empty slot
    def has_space?
      @filled < @size
    end

    # @return [Boolean] true if the bucket has no empty slots
    def empty?
      @filled.zero?
    end
  end
end
