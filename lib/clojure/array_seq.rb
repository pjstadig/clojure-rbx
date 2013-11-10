# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
require 'clojure/seq'
require 'clojure/sequential'

module Clojure
  class ArraySeq
    class << self
      protected :new

      def create(array, index = 0)
        if index < 0 || index > array.length
          raise IndexError, "#{index} out of range"
        end
        if array.nil? || array.empty? || index == array.length
          return Seq::EMPTY
        end
        new(array, index).freeze
      end
    end

    include Seq
    include Sequential

    def initialize(array, index)
      @array = array
      @index = index
    end

    def first
      @array[@index]
    end

    def rest
      if @index + 1 < @array.length
        ArraySeq.create(@array, @index + 1)
      else
        empty
      end
    end

    def next
      if @index + 1 < @array.length
        ArraySeq.create(@array, @index + 1)
      else
        nil
      end
    end

    def seq
      self
    end
  end
end
