require 'test_helper'

module CuckooFilter
  class FingerprintTest < Minitest::Test
    def test_fingerprint_works
      expected_fingerprint = 3582672807
      assert_equal Fingerprint.new("hello world").value, expected_fingerprint
    end

    def test_fingerprint_is_nil_by_default
      assert_nil Fingerprint.new.value
    end

    def test_fingerprint_reset_works
      fp = Fingerprint.new("hello world")
      refute_nil fp.value
      fp.clear!
      assert_nil fp.value
    end

    def test_updating_fingerprint
      fp = Fingerprint.new
      new_fp = Fingerprint.new("hello world")
      fp.set(new_fp)
      expected_fingerprint = 3582672807
      assert_equal fp.value, expected_fingerprint
    end

    def test_updating_fingerprint_when_non_nil
      fp = Fingerprint.new("hello world")
      refute_nil fp.value
      assert_raises(CuckooFilterError) { fp.set("new value") }
    end

    def test_empty_fingerprint
      assert Fingerprint.new.empty?
      refute Fingerprint.new("").empty?
    end
  end
end
