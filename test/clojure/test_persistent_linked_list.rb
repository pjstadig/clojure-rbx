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

class TestPersistentLinkedList < ClojureTestCase
  EMPTY = Clojure::PersistentLinkedList::EMPTY

  def create(array)
    Clojure::PersistentLinkedList.create(array)
  end

  def test_create
    assert_equal(EMPTY, create(nil))
  end

  def test_conj
    assert_equal(EMPTY, create([]))
    assert_equal(create([]), EMPTY)
    assert_equal(EMPTY, create([1, 2]).empty)
    assert_equal(create([1, 2]).empty, EMPTY)
    assert_equal(EMPTY, create([1, 2]).pop.pop)
    assert_equal(create([1, 2]).pop.pop, EMPTY)
    assert_equal(create([1]), EMPTY.conj(1))
    assert_equal(EMPTY.conj(1), create([1]))
    assert_equal(create([2, 1]), create([1]).conj(2))
    assert_equal(create([1]).conj(2), create([2, 1]))
  end

  def test_peek
    assert_equal(1, create([1,2,3]).peek)
    assert_nil(EMPTY.peek)
  end

  def test_pop
    list = create([1,2,3])
    list = list.pop
    assert_equal(create([2, 3]), list)
    list = list.pop
    assert_equal(create([3]), list)
    list = list.pop
    assert_equal(EMPTY, list)
    begin
      list.pop
      flunk("should raise error")
    rescue
    end
  end

  def test_seq
    assert_nil(EMPTY.seq)
    seq = create([1, 2, 3]).seq
    assert_equal(vector([1, 2, 3]), seq)
    assert_equal(seq, vector([1, 2, 3]))
    assert_equal(3, seq.count)
    assert_equal(1, seq.first)
    seq = seq.next
    assert_equal(2, seq.first)
    seq = seq.next
    assert_equal(3, seq.first)
    assert_nil(seq.next)
  end

  def test_to_a
    assert_equal([1, 2, 3], create([1, 2, 3]).seq.to_a)
  end
end
