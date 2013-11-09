# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
require 'clojure/associative'
require 'clojure/counted'

module Clojure
  module PersistentMap
    include Associative
    include Counted

    def ==(obj)
      return false unless Clojure.map?(obj)
      return false unless count == obj.count
      ks = keys
      until ks.nil?
        k = ks.first
        return false unless Clojure.equiv(val_at(k), obj.val_at(k))
        ks = ks.next
      end
      ks = obj.keys
      until ks.nil?
        k = ks.first
        return false unless Clojure.equiv(val_at(k), obj.val_at(k))
        ks = ks.next
      end
      true
    end

    def conj(obj)
      k = Clojure.first(obj)
      v = Clojure.second(obj)
      put(k, v)
    end

    # def count; raise; end
    # def empty; raise; end

    def empty?
      seq.nil?
    end

    def equiv(obj)
      self == obj
    end

    # def entry_at(key); raise; end

    # def has_key?(key); raise; end
    # def has_value?(value); raise; end
    # def include?(key); raise; end
    # def keys; raise; end
    # def put(key, val); raise; end
    # def val_at(key, not_found = nil); raise; end
    # def values; raise; end
    # def seq; raise; end
    # def without(key); raise; end

  end
end
