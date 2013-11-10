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
require 'stringio'

class TestPersistentArrayMap < ClojureTestCase
  def read(str)
    Clojure::Reader.new(StringIO.new(str)).read
  end

  def test_read_symbol
    assert_equal(symbol(nil, "foo"), read("foo"))
    assert_equal(symbol("foo", "bar"), read("foo/bar"))
  end

  def test_read_number
    assert_eql(12, read("12"))
    assert_eql(-12, read("-12"))
    assert_eql(12, read("12N"))
    assert_eql(12.5, read("12.5"))
    assert_eql(12.5E1, read("12.5E1"))
    assert_eql(12.5E-1, read("12.5E-1"))
    assert_eql(read("12.5M"), "12.5".to_d)
    assert_eql(read("12.5E1M"), "12.5E1".to_d)
    assert_eql(read("12.5E-1M"), "12.5E-1".to_d)
    assert_eql(Rational(1, 2), read("1/2"))
  end

  def test_read_list
    assert_equal(list([1, 2]), read("(1 2)"))
  end

  def test_read_vector
    assert_equal(vector([1, 2]), read("[1 2]"))
  end

  def test_read_set
    assert_equal(set([1, 2]), read("\#{1 2}"))
  end

  def test_read_map
    assert_equal(map([1, 2, 3, 4]), read("{1 2, 3 4}"))
    assert_raises(RuntimeError) do
      read("{1 2, 3}")
    end
  end
end
