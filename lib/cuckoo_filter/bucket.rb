module CuckooFilter
  class Bucket
    attr_reader :size, :slots

    def initialize(size)
      @size = size
      @filled = 0
      @slots = Array.new(@size) { Fingerprint.new }
    end

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

    def remove(fingerprint)
      if contains?(fingerprint)
        @filled = [(@filled - 1), 0].max
        slot = @slots.find { |slot| slot.value == fingerprint.value }
        slot.clear!
      end
    end

    def random_swap(fingerprint)
      random_index = rand(@size)
      fingerprint, @slots[random_index] = @slots[random_index], fingerprint
      fingerprint
    end

    def contains?(fingerprint)
      @slots.any? { |slot| slot.value == fingerprint.value }
    end

    def clear!
      @slots.map(&:clear!)
      @filled = 0
    end

    def has_space?
      @filled < @size
    end

    def empty?
      @filled.zero?
    end
  end
end
