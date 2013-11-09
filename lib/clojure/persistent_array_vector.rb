# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
require 'clojure/persistent_vector'

module Clojure
  class PersistentArrayVector
    class << self
      private :new

      def create(values)
        return EMPTY if values.nil? || values.empty?
        new(values.dup).freeze
      end

      def create_internal(values)
        new(values).freeze
      end
    end

    include PersistentVector

    def initialize(values)
      @values = values.freeze
    end

    def conj(obj)
      values = Array.new(count + 1)
      values[0...count] = @values[0...count]
      values[count] = obj
      PersistentArrayVector.create_internal(values)
    end

    def count
      @values.length
    end

    def empty
      EMPTY
    end

    def entry_at(key)
      if !key.is_a?(Integer)
        raise TypeError, "Coercion error: #{key}.to_int => Fixnum failed"
      end
      key = key.to_int
      if 0 <= key && key < count
        [key, @values[key]]
      else
        raise IndexError, "#{key} out of bounds" unless key > 0
      end
    end

    def has_key?(key)
      key.is_a?(Integer) && 0 <= key && key < count
    end

    def length
      @values.length
    end

    def nth(i, not_found = nil)
      if !i.is_a?(Integer) && !i.respond_to?(:to_int)
        raise TypeError, "Coercion error: #{i}.to_int => Fixnum failed"
      end
      i = i.to_int
      if i.is_a?(Integer) && 0 <= i && i < count
        @values[i]
      else
        not_found
      end
    end

    def peek()
      @values[count - 1]
    end

    def pop()
      return empty if length == 1
      values = Array.new(count - 1)
      values[0...values.length] = @values[0...values.length]
      PersistentArrayVector.create_internal(values)
    end

    def put(key, val)
      if !key.is_a?(Integer) && !key.respond_to?(:to_int)
        raise TypeError, "Coercion error: #{key}.to_int => Fixnum failed"
      end
      key = key.to_int
      if key < 0 || count < key
        raise IndexError, "#{key} out of bounds"
      end
      values = @values.dup
      values.fill(nil, count...key)
      values[key] = val
      PersistentArrayVector.create_internal(values)
    end

    def val_at(key, not_found = nil);
      if !key.is_a?(Integer) && !key.respond_to?(:to_int)
        raise TypeError, "Coercion error: #{key}.to_int => Fixnum failed"
      end
      key = key.to_int
      if key.is_a?(Integer) && -count <= key && key < count
        @values[key]
      else
        not_found
      end
    end

    def rseq
      ArrayRSeq.create(@values)
    end

    def seq
      Clojure.seq(@values)
    end

    class Empty
      include PersistentVector

      def assoc(key)
        nil
      end

      def conj(obj)
        PersistentArrayVector.create([obj])
      end

      def count
        0
      end

      def empty
        self
      end

      def equiv(obj)
        (obj.is_a?(PersistentVector) || obj.is_a?(Sequential)) && obj.seq.nil?
      end

      def has_key?(key)
        nil
      end

      def length;
        0
      end

      def nth(i, not_found = nil);
        not_found
      end

      def peek();
        nil
      end

      def pop();
        raise "cannot pop empty vector"
      end

      def put(key, val);
        if !key.is_a?(Integer) && !key.respond_to?(:to_int)
          raise TypeError, "Coercion error: #{key}.to_int => Fixnum failed"
        end
        key = key.to_int
        if key != 0
          raise IndexError, "#{key} out of bounds"
        end
        PersistentArrayVector.create_internal([val])
      end

      def val_at(key, not_found = nil);
        not_found
      end

      def rseq
        nil
      end

      def seq
        nil
      end
    end

    EMPTY = Empty.new
  end
end
