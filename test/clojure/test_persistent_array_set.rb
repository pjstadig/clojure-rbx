require 'helper'

class TestPersistentArraySet < ClojureTestCase
  EMPTY = Clojure::PersistentArraySet::EMPTY

  def create(array)
    Clojure::PersistentArraySet.create(array)
  end

  def test_conj
    assert_equal(EMPTY, create([]))
    assert_equal(create([]), EMPTY)
    assert_equal(EMPTY, create([1, 2]).disj(1).disj(2))
    assert_equal(create([1, 2]).disj(1).disj(2), EMPTY)
    assert_equal(EMPTY, create([1, 2]).empty)
    assert_equal(create([1, 2]).empty, EMPTY)
    assert_equal(create([1, 2]), EMPTY.conj(1).conj(2))
    assert_equal(EMPTY.conj(1).conj(2), create([1, 2]))
    assert_equal(create([1, 2]), EMPTY.conj(2).conj(1))
    assert_equal(EMPTY.conj(2).conj(1), create([1, 2]))
  end

  def test_to_a
    assert_equal([1, 2, 3], create([1, 2, 3]).seq.to_a)
  end

  def test_seq
    set = create([1, 2, 3])
    seq = set.seq
    assert_equal(3, seq.count)
    assert_equal(vector([1, 2, 3]), seq)
    assert_equal(seq, vector([1, 2, 3]))
    assert_equal(1, seq.first)
    seq = seq.next
    assert_equal(2, seq.first)
    seq = seq.next
    assert_equal(3, seq.first)
    assert_nil(seq.next)
  end
end
