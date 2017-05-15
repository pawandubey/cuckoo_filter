require 'fnv'

module CuckooFilter
  # A fingerprint is a fixed size "hash" of an element which is stored
  # in one of the buckets of the Cuckoo Filter.
  #
  # Typically modeled as just a collection of bits (generally 6), since
  # Ruby doesn't allow that low level an access to the memory, we just go ahead
  # with a full blown class.
  #
  # value stores the actual value of the fingerprint
  class Fingerprint
    # @return [Numeric] the actual calculated FNV-1a fingerprint
    attr_reader :value

    # Creates a new fingerprint with the provided item, or without any
    # actual fingerprint value if no item is provided
    def initialize(item = nil)
      @value = self.class.make(item).freeze unless item.nil?
    end

    # Update the value of a fingerprint if it was created without
    # an item (i.e. the value is nil), else return error
    #
    # @param fingerprint [Fingerprint] the fingerprint with which to update the value
    def set(fingerprint)
      if @value.nil?
        @value = fingerprint.value.freeze
      else
        fail CuckooFilterError, "Fingerprint value cannot be changed once set"
      end
    end

    # Clear the value and return the old value encapsulated in a new {Fingerprint}
    def clear!
      old_value = self.dup
      @value = nil
      old_value
    end

    def empty?
      @value.nil?
    end

    def self.make(item)
      Fnv::Hash.fnv_1a(item, size: 32)
    end
  end
end
