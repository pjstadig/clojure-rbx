require 'helper'

class TestPersistentArrayMap < ClojureTestCase
  EMPTY = Clojure::PersistentArrayMap::EMPTY

  def create(array)
    Clojure::PersistentArrayMap.create(array)
  end

  def test_conj
    assert_equal(EMPTY, create([]))
    assert_equal(create([]), EMPTY)
    assert_equal(EMPTY, create([1, 2, 3, 4]).empty)
    assert_equal(create([1, 2, 3, 4]).empty, EMPTY)
    assert_equal(EMPTY, create([1, 2, 3, 4]).without(1).without(3))
    assert_equal(create([1, 2, 3, 4]).without(1).without(3), EMPTY)
    assert_equal(create([3, 4, 1, 2]), EMPTY.conj([1, 2]).conj([3, 4]))
    assert_equal(EMPTY.conj([1, 2]).conj([3, 4]), create([3, 4, 1, 2]))
  end

  def test_keys
    assert_nil(EMPTY.keys)
    seq = create([1, 2, 3, 4]).keys
    assert_equal(2, seq.count)
    assert_equal(1, seq.first)
    seq = seq.next
    assert_equal(3, seq.first)
    assert_nil(seq.next)
  end

  def test_to_a
    map = create([1, 2, 3, 4])
    assert_equal([[1, 2], [3, 4]], map.seq.to_a)
  end

  def test_seq
    assert_nil(EMPTY.seq)
    seq = create([1, 2, 3, 4]).seq
    assert_equal(2, seq.count)
    assert_equal([1, 2], seq.first)
    seq = seq.next
    assert_equal([3, 4], seq.first)
    assert_nil(seq.next)
  end

  def test_values
    assert_nil(EMPTY.values)
    seq = create([1, 2, 3, 4]).values
    assert_equal(2, seq.count)
    assert_equal(2, seq.first)
    seq = seq.next
    assert_equal(4, seq.first)
    assert_nil(seq.next)
  end
end
