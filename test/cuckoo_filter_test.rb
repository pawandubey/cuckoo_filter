require 'test_helper'

class CuckooFilterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CuckooFilter::VERSION
  end
end
