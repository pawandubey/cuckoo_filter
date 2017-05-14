require 'fnv'

module CuckooFilter
  class Fingerprint
    attr_reader :value

    def initialize(item = nil)
      @value = self.class.make(item).freeze unless item.nil?
    end

    def set(fingerprint)
      if @value.nil?
        @value = fingerprint.value.freeze
      else
        fail CuckooFilterError, "Fingerprint value cannot be changed once set"
      end
    end

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
