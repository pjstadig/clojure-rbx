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

class TestPersistentArrayVector < ClojureTestCase
  EMPTY = Clojure::PersistentArrayVector::EMPTY

  def create(array)
    Clojure::PersistentArrayVector.create(array)
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
    assert_equal(create([1, 2]), create([1]).conj(2))
    assert_equal(create([1]).conj(2), create([1, 2]))
  end

  def test_entry_at
    vec = create([1, 2, 3])
    begin
      vec.entry_at(:foo)
      flunk "should raise TypeError"
    rescue TypeError
    rescue
      flunk "should raise TypeError"
    end
    begin
      vec.entry_at(-1)
      flunk "should raise IndexError"
    rescue IndexError
    rescue
      flunk "should raise IndexError"
    end
    assert_equal([1, 2], vec.entry_at(1))
    assert_nil(vec.entry_at(3))
  end

  def test_peek
    assert_equal(3, create([1,2,3]).peek)
    assert_nil(EMPTY.peek)
  end

  def test_put
    vec = create([1, 2, 3])
    assert_equal(create([:foo, 2, 3]), vec.put(0, :foo))
    assert_equal(create([1, 2, 3, :foo]), vec.put(vec.count, :foo))
    begin
      vec.put(-1, :foo)
      flunk("should raise IndexError")
    rescue IndexError
    rescue
      flunk("should raise IndexError")
    end
    begin
      vec.put(vec.count + 1, :foo)
      flunk("should raise IndexError")
    rescue IndexError
    rescue
      flunk("should raise IndexError")
    end
  end

  def test_pop
    vec = create([1,2,3])
    vec = vec.pop
    assert_equal(create([1, 2]), vec)
    vec = vec.pop
    assert_equal(create([1]), vec)
    vec = vec.pop
    assert_equal(EMPTY, vec)
    begin
      vec.pop
      flunk("should raise error")
    rescue
    end
  end

  def test_rseq
    assert_nil(EMPTY.seq)
    seq = create([1, 2, 3]).rseq
    assert_equal(3, seq.count)
    assert_equal(3, seq.first)
    seq = seq.next
    assert_equal(2, seq.first)
    seq = seq.next
    assert_equal(1, seq.first)
    assert_nil(seq.next)
  end

  def test_seq
    assert_nil(EMPTY.seq)
    seq = create([1, 2, 3]).seq
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

  def test_val_at
    vec = create([1, 2, 3])
    begin
      vec.val_at(:foo)
      flunk "should raise error"
    rescue
    end
    assert_equal(2, vec.val_at(1))
    assert_equal(3, vec.val_at(-1))
    assert_nil(vec.val_at(3))
    assert_nil(vec.val_at(-4))
    assert_equal(:foo, vec.val_at(3, :foo))
    assert_equal(:foo, vec.val_at(-4, :foo))
  end
end
