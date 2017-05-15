require 'test_helper'

module CuckooFilter
  class CuckooFilterTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::CuckooFilter::VERSION
    end

    def setup
      @cf = CuckooFilter.new(size: 2000, bucket_size: 8)
    end

    def test_bucket_and_overall_size
      assert_equal 2048, @cf.size
      assert_equal 8, @cf.bucket_size
      assert_equal 2048 / 8, @cf.num_buckets
    end

    def test_insertion
      assert_equal 0, @cf.filled
      assert @cf.insert("hello world")
      assert_equal 1, @cf.filled

      assert @cf.insert("hello")
      assert_equal 2, @cf.filled
    end

    def test_lookup
      @cf.insert("hello world")
      assert @cf.lookup("hello world")

      refute @cf.lookup("hello")
      @cf.insert("hello")
      assert @cf.lookup("hello")
    end

    def test_deletion
      assert @cf.insert("hello world")
      assert @cf.lookup("hello world")

      refute @cf.lookup("hello")
      assert @cf.insert("hello")
      assert @cf.lookup("hello")

      assert @cf.delete("hello world")
      refute @cf.lookup("hello world")
      assert_equal 1, @cf.filled

      assert @cf.delete("hello")
      refute @cf.lookup("hello")
      assert_equal 0, @cf.filled

      refute @cf.delete("hello")
    end

    def test_insertion_on_filled_filter
      cf = CuckooFilter.new(size: 4)
      %w[hello world foo bar].each do |item|
        assert cf.insert(item)
      end

      assert_equal cf.size, cf.filled

      refute cf.insert("new val")
      assert cf.delete("foo")
      assert_equal cf.size - 1, cf.filled

      assert cf.insert("new val")
      assert_equal cf.size, cf.filled
    end

    def test_deletion_on_empty_filter
      assert_equal 0, @cf.filled
      refute @cf.delete("foo")
    end

    def test_alt_index_is_commutative
      fingerprint = 5412
      index = 45
      alt_index = @cf.send(:alt_index, index, fingerprint)
      assert_equal index, @cf.send(:alt_index, alt_index, fingerprint)
    end
  end
end
