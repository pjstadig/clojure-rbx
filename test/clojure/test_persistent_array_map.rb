# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
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
    assert_equal(vector([1, 3]), seq)
    assert_equal(seq, vector([1, 3]))
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
    assert_equal(vector([[1, 2], [3, 4]]), seq)
    assert_equal(seq, vector([[1, 2], [3, 4]]))
    assert_equal(2, seq.count)
    assert_equal([1, 2], seq.first)
    seq = seq.next
    assert_equal([3, 4], seq.first)
    assert_nil(seq.next)
  end

  def test_values
    assert_nil(EMPTY.values)
    seq = create([1, 2, 3, 4]).values
    assert_equal(vector([2, 4]), seq)
    assert_equal(seq, vector([2, 4]))
    assert_equal(2, seq.count)
    assert_equal(2, seq.first)
    seq = seq.next
    assert_equal(4, seq.first)
    assert_nil(seq.next)
  end
end
