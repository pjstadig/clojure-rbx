# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
module Clojure
  class Var
    class << self
      def intern(name, root = UNBOUND)
        Namespace.intern(name.namespace).intern(name.name, root)
      end

      def push_bindings(*args)
        raise "expected even number of arguments" unless args.length.even?
        raise "expected at least one binding" unless args.length > 0
        bindings = nil
        while args.length > 0
          k, v, *args = *args
          bindings = Clojure.put(bindings, k, v)
        end
        binding_stack = Thread.current[:bindings]
        Thread.current[:bindings] = Clojure.conj(binding_stack, bindings)
      end

      def pop_bindings()
        unless Clojure.seq(Thread.current[:bindings])
          raise "cannot pop empty bindings"
        end
        Thread.current[:bindings] = Clojure.pop(Thread.current[:bindings])
      end
    end

    UNBOUND = Object.new

    attr_accessor :name

    def initialize(name, root)
      @name = name
      @root = Atomic.new(root)
    end

    def deref
      bindings = Clojure.peek(Thread.current[:bindings])
      if bindings && bindings.include?(self)
        bindings.val_at(self)
      else
        root
      end
    end

    def root
      val = @root.value
      raise "#{@name} is unbound" if val == UNBOUND
      val
    end

    def set!(value)
      binding_stack = Thread.current[:bindings]
      bindings = Clojure.peek(binding_stack)
      unless bindings && bindings.include?(self)
        raise "no binding established for #{name || self}"
      end
      bindings = Clojure.put(bindings, self, value)
      binding_stack = Clojure.conj(Clojure.pop(binding_stack), bindings)
      Thread.current[:bindings] = binding_stack
    end

    def set_root!(value)
      @root.value = value
    end
  end
end
