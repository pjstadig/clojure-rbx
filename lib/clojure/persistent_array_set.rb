# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
require 'clojure/persistent_set'

module Clojure
  class PersistentArraySet
    class << self
      private :new

      def create(values)
        return PersistentArraySet::EMPTY if values.nil? || values.empty?
        (0...values.length).each do |i|
          (i+1...values.length).each do |j|
            if Clojure.equiv(values[i], values[j])
              raise "duplicate value #{values[i]}"
            end
          end
        end
        new(values.dup).freeze
      end

      def create_internal(values)
        new(values).freeze
      end
    end

    include PersistentSet

    def initialize(values)
      @values = values.freeze
    end

    def conj(obj)
      index = key_index(obj)
      return self unless index == -1
      values = Array.new(@values.length + 1)
      values[0...@values.length] = @values
      values[@values.length] = obj
      PersistentArraySet.create_internal(values)
    end

    def count
      @values.length
    end

    def disj(key)
      i = key_index(key)
      return self if i == -1
      return empty if count == 1
      length = @values.length - 1
      values = Array.new(length)
      values[0...i] = @values[0...i]
      values[i...values.length] = @values[(i+1)...@values.length]
      PersistentArraySet.create_internal(values)
    end

    def empty
      EMPTY
    end

    def include?(key)
      key_index(key) != -1
    end

    def seq
      Clojure.seq(@values)
    end

    class Empty
      include PersistentSet

      def conj(obj)
        PersistentArraySet.create_internal([obj])
      end

      def count
        0
      end

      def disj(key)
        self
      end

      def empty
        self
      end

      def empty?
        true
      end

      def equiv(obj)
        Clojure.set?(obj) && obj.seq.nil?
      end

      def get(key)
        nil
      end

      def member?(key)
        false
      end

      def seq
        nil
      end
    end

    EMPTY = Empty.new

    private

    def key_index(key)
      (0...@values.length).each do |i|
        return i if Clojure.equiv(key, @values[i])
      end
      -1
    end
  end
end
