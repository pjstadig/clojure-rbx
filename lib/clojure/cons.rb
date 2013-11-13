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

module Clojure
  class Cons
    class << self
      private :new

      def create(first, rest = nil)
        rest ||= Seq::EMPTY
        new(first, rest).freeze
      end
    end

    include Seq
    include Sequential

    def initialize(first, rest)
      raise TypeError, "expected seq for rest" unless Clojure.seq?(rest)
      @first = first
      @rest = rest
    end

    def first
      @first
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
  end
end
