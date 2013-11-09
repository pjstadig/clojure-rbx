# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
require 'clojure/counted'
require 'clojure/persistent_array_set'
require 'clojure/persistent_collection'

module Clojure
  module PersistentSet
    include PersistentCollection
    include Counted

    def ==(obj)
      return false unless Clojure.set?(obj)
      return false unless count == obj.count
      s = obj.seq
      until s.nil?
        return false unless member?(s.first)
        s = s.next
      end
      s = seq
      until s.nil?
        return false unless obj.member?(s.first)
        s = s.next
      end
      true
    end

    # def conj(obj); raise; end
    # def count; raise; end
    # def disj(key); raise; end
    # def empty; raise; end

    def empty?
      seq.nil?
    end

    def equiv(obj)
      self == obj
    end

    def get(key)
      key if member?(key)
    end

    # def include?(key); raise; end

    def member?(key)
      include?(key)
    end

    # def seq; raise; end
  end
end
