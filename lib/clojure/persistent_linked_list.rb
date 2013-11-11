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
require 'clojure/persistent_list'
require 'clojure/seq'

module Clojure
  class PersistentLinkedList
    class << self
      private :new

      def create(*args)
        case args.count
        when 1
          if args[0].nil?
            EMPTY
          elsif args[0].is_a?(Array)
            i = args[0].length - 1
            list = EMPTY
            until i < 0
              list = list.conj(args[0][i])
              i -= 1
            end
            list
          else
            new(first, nil, 0).freeze
          end
        when 3
          first, rest, count = *args
          rest ||= EMPTY
          count ||= 0
          new(first, rest, count).freeze
        else
          raise ArgumentError, "method 'create': given #{args.count}," +
            " expected 1-3"
        end
      end
    end

    include Seq
    include PersistentList
    include Counted

    def initialize(first, rest, count)
      raise TypeError, "expected rest to be a list" unless Clojure.list?(rest)
      @first = first
      @rest = rest
      @count = count
    end

    def conj(obj)
      PersistentLinkedList.create(obj, self, @count + 1)
    end

    def count
      @count
    end

    def first
      @first
    end

    def peek()
      @first
    end

    def pop()
      @rest
    end

    def rest
      @rest
    end

    def next
      @rest.seq
    end

    def seq
      self
    end

    class Empty
      include Seq
      include PersistentList
      include Counted

      def conj(obj)
        PersistentLinkedList.create(obj, self, 1)
      end

      def count
        0
      end

      def first
        nil
      end

      def peek()
        nil
      end

      def pop()
        raise "cannot pop empty vector"
      end

      def rest
        @rest
      end

      def next
        nil
      end

      def seq
        nil
      end
    end

    EMPTY = Empty.new
  end
end
