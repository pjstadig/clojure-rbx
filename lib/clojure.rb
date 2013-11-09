# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
module Clojure
  class << self
    def coll?(coll)
      coll.is_a?(PersistentCollection)
    end

    def conj(coll, obj)
      if coll.nil?
        Cons.create(obj)
      elsif coll?(coll)
        coll.conj(obj)
      else
        raise "conj not supported on #{coll.class}"
      end
    end

    def cons(obj, coll)
      Cons.create(obj, coll)
    end

    def count(obj)
      if obj.nil?
        0
      elsif coll?(obj)
        obj.count
      elsif counted?(obj)
        obj.count
      else
        raise "count not supported on #{obj.class}"
      end
    end

    def counted?(obj)
      obj.is_a?(Counted)
    end

    def equiv(obj1, obj2)
      if obj1.nil?
        obj2.nil?
      elsif coll?(obj1)
        obj1.equiv(obj2)
      else
        obj1 == obj2
      end
    end

    def first(obj)
      s = seq(obj)
      if s.nil?
        nil
      else
        s.first
      end
    end

    def map?(obj)
      obj.is_a?(PersistentMap)
    end

    def next(obj)
      if seq?(obj)
        obj.next
      else
        seq(rest(obj))
      end
    end

    def rest(obj)
      s = seq(obj)
      if s.nil?
        nil
      else
        s.rest
      end
    end

    def second(obj)
      s = Clojure.next(obj)
      if s.nil?
        nil
      else
        s.first
      end
    end

    def set?(obj)
      obj.is_a?(PersistentSet)
    end

    def seq(obj)
      if obj.nil?
        nil
      elsif obj.is_a?(Array)
        ArraySeq.create(obj)
      elsif seq?(obj)
        obj.seq
      else
        raise "seq not supported on #{obj.class}"
      end
    end

    def seq?(obj)
      obj.is_a?(Seq)
    end

    def sequential?(obj)
      obj.is_a?(Sequential)
    end

    def vector?(obj)
      obj.is_a?(PersistentVector)
    end
  end
end

Dir[File.dirname(__FILE__) + '/clojure/*.rb'].each do |file|
  require file
end
