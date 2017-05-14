require 'test_helper'

module CuckooFilter
  class BucketTest < Minitest::Test
    def setup
      @bucket = Bucket.new(4)
      @fps = []
      (1..4).each do |i|
        @fps << Fingerprint.new(i)
      end
    end

    def teardown
      @bucket.clear!
    end

    def test_empty_bucket
      assert @bucket.empty?
    end

    def test_bucket_size
      assert_equal @bucket.size, 4
      assert_equal @bucket.slots.size, @bucket.size
    end

    def test_slot_uniqueness_in_bucket
      object_ids = @bucket.slots.map(&:object_id).uniq
      assert_equal object_ids.size, @bucket.size
    end

    def test_containment
      assert @bucket.empty?
      refute @bucket.contains?(@fps.first)

      @bucket.insert(@fps.first)
      @bucket.insert(@fps.last)
      assert @bucket.contains?(@fps.first)
      assert @bucket.contains?(@fps.last)

      @bucket.remove(@fps.first)
      refute @bucket.contains?(@fps.first)
      assert @bucket.contains?(@fps.last)

      assert @bucket.has_space?
      refute @bucket.empty?

      @bucket.clear!
      assert @bucket.empty?

      @fps.each do |fp|
        @bucket.insert(fp)
        assert @bucket.contains?(fp)
      end

      refute @bucket.has_space?
    end
  end
end
