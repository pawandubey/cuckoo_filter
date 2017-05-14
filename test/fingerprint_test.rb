require 'test_helper'

module CuckooFilter
  class FingerprintTest < Minitest::Test
    def setup
      @fp = Fingerprint.new("hello world")
    end

    def test_fingerprint_works
      expected_fingerprint = 3582672807
      assert_equal @fp.value, expected_fingerprint
    end

    def test_fingerprint_is_nil_by_default
      assert_nil Fingerprint.new.value
    end

    def test_fingerprint_reset_works
      refute_nil @fp.value
      @fp.clear!
      assert_nil @fp.value
    end

    def test_updating_fingerprint
      new_fp = Fingerprint.new
      new_fp.set(@fp)
      expected_fingerprint = 3582672807
      assert_equal new_fp.value, expected_fingerprint
    end

    def test_updating_fingerprint_when_non_nil
      refute_nil @fp.value
      assert_raises(CuckooFilterError) { @fp.set("new value") }
    end

    def test_empty_fingerprint
      assert Fingerprint.new.empty?
      refute Fingerprint.new("").empty?
    end
  end
end
