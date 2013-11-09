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
require 'clojure/indexed'
require 'clojure/persistent_stack'
require 'clojure/reversible'
require 'clojure/sequential'

module Clojure
  module PersistentVector
    include Associative
    include Sequential
    include PersistentStack
    include Reversible
    include Indexed

    def ==(obj)
      if Clojure.vector?(obj)
        return false unless count == obj.count
        (0...count).each do |i|
          return false unless Clojure.equiv(val_at(i), obj.val_at(i))
        end
      elsif Clojure.sequential?(obj)
        i = 0
        s = obj.seq
        until i >= count || s.nil?
          return false if Clojure.equiv(val_at(i), s.first)
          s = s.next
          i += 1
        end
        return false unless s.nil?
      end
      true
    end

    def conj(obj);
      put(count, obj)
    end

    # def count; raise; end
    # def empty; raise; end
    # def entry_at(key); raise; end

    def equiv(obj)
      self == obj
    end

    # def has_key?(key); raise; end
    # def length; raise; end
    # def nth(i, not_found = nil); raise; end
    # def peek(); raise; end
    # def pop(); raise; end
    # def put(key, val); raise; end
    # def val_at(key, not_found = nil); raise; end
    # def rseq; raise; end
    # def seq; raise; end
  end
end
