# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
require 'clojure/cons'
require 'clojure/persistent_collection'

module Clojure
  module Seq
    include PersistentCollection

    def conj(obj)
      Cons.create(obj, self)
    end

    def count
      c = 0
      s = self
      until s.nil?
        c += 1
        s = s.next
      end
      c
    end

    def empty
      EMPTY
    end

    def equiv(obj)
      return false unless Clojure.seq?(obj)
      s1 = self
      s2 = obj
      until s1.nil? || s2.nil?
        return false unless Clojure.equiv(s1.first, s2.first)
        s1 = s1.next
        s2 = s2.next
      end
      s1.nil? && s2.nil?
    end

    # def first; raise; end
    # def rest; raise; end
    # def next; raise; end
    # def seq; raise; end

    class Empty
      include Seq

      def count
        0
      end

      def empty
        self
      end

      def equiv(obj)
        Clojure.seq?(obj) && Clojure.seq(obj).nil?
      end

      def first
        nil
      end

      def rest
        self
      end

      def next
        nil
      end

      def seq
        nil
      end
    end

    EMPTY = Empty.new.freeze
  end
end
