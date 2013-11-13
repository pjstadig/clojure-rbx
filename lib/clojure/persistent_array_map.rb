# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
require 'clojure/persistent_map'
require 'clojure/sequential'

module Clojure
  class PersistentArrayMap
    class << self
      private :new

      def create(values)
        return EMPTY if values.nil? || values.empty?
        raise "expected an even number of values" if values.length.odd?
        new(values.dup).freeze
      end

      def create_internal(values)
        new(values).freeze
      end
    end

    include PersistentMap

    def initialize(values)
      @values = values.freeze
    end

    def count
      @values.length / 2
    end

    def empty
      EMPTY
    end

    def entry_at(key)
      i = key_index(key)
      if i > 0
        [@values[i], @values[i+1]]
      end
    end

    def has_key?(key)
      key_index(key) != -1
    end

    def has_value?(value)
      value_index(value) != -1
    end

    alias_method :include?, :has_key?

    def keys
      KeySeq.new(@values)
    end

    def put(key, val);
      i = key_index(key)
      if i >= 0
        values = @values.dup
        values[i+1] = val
      else
        length = @values.length
        values = Array.new(length + 2)
        values[0...length] = @values
        values[length] = key
        values[length+1] = val
      end
      PersistentArrayMap.create_internal(values)
    end

    def val_at(key, not_found = nil)
      i = key_index(key)
      if i >= 0
        @values[i+1]
      else
        not_found
      end
    end

    def values
      KeySeq.new(@values, 1)
    end

    def seq
      EntrySeq.new(@values)
    end

    def without(key)
      i = key_index(key)
      if i >= 0
        return empty if count == 1
        length = @values.length
        values = Array.new(length - 2)
        values[0...i] = @values[0...i]
        values [i...(length - 2)] = @values[(i+2)...length]
        PersistentArrayMap.create_internal(values)
      else
        self
      end
    end

    class KeySeq
      include Seq
      include Sequential

      def initialize(values, index = 0)
        @values = values
        @index = index
      end

      def first
        @values[@index]
      end

      def rest
        if @index + 2 < @values.length
          KeySeq.new(@values, @index + 2)
        else
          empty
        end
      end

      def next
        if @index + 2 < @values.length
          KeySeq.new(@values, @index + 2)
        else
          nil
        end
      end

      def seq
        self
      end
    end

    class EntrySeq
      include Seq
      include Sequential

      def initialize(values, index = 0)
        @values = values
        @index = index
      end

      def first
        [@values[@index], @values[@index+1]]
      end

      def rest
        if @index + 2 < @values.length
          EntrySeq.new(@values, @index + 2)
        else
          empty
        end
      end

      def next
        if @index + 2 < @values.length
          EntrySeq.new(@values, @index + 2)
        else
          nil
        end
      end

      def seq
        self
      end
    end

    class Empty
      include PersistentMap

      def assoc(key);
        nil
      end

      def count
        0
      end

      def empty
        self
      end

      def empty?
        true
      end

      def equiv(obj)
        Clojure.map?(obj) && obj.empty?
      end

      def has_key?(key)
        false
      end

      def has_value?(value)
        false
      end

      def include?(key)
        has_key?(key)
      end

      def keys
        nil
      end

      def put(key, val)
        PersistentArrayMap.create_internal([key, val])
      end

      def val_at(key, not_found = nil)
        not_found
      end

      def values
        nil
      end

      def seq
        nil
      end

      def without(key)
        self
      end
    end

    EMPTY = Empty.new

    private

    def key_index(key)
      i = 0
      while i < @values.length
        return i if Clojure.equiv(key, @values[i])
        i += 2
      end
      -1
    end

    def value_index(value)
      i = 1
      while i < @values.length
        return i if Clojure.equiv(value, @values[i])
        i += 2
      end
      -1
    end
  end
end
