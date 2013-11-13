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
  class Compiler
    class << self
      def compile(exp, g)
        if exp.nil?
          g.push_nil
        elsif Clojure.list?(exp)
          if Clojure.seq(exp)
            compile_list(exp, g)
          else
            g.push_const :Clojure
            g.find_const :PersistentLinkedList
            g.find_const :EMPTY
          end
        elsif exp.is_a?(Clojure::Symbol)
          if exp.namespace
            if Var.resolve(exp)
              g.push_const :Clojure
              g.find_const :Var
              g.push_const :Clojure
              g.find_const :Symbol
              g.push_literal exp.namespace
              g.push_literal exp.name
              g.send :create, 2, false
              g.send :resolve, 1, false
            else
              raise "cannot resolve #{exp}"
            end
          else
            raise "cannot compile non-namespaced symbol"
          end
        else
          compile_literal(exp, g)
        end
      end

      def compile_list(exp, g)
        f = Clojure.first(exp)
        if f == Symbol.create("quote")
          compile_literal(Clojure.second(exp), g)
        elsif f == Symbol.create(".")
          s = Clojure.next(exp)
          raise "expected a receiver" unless Clojure.count(s) >= 1
          compile(s.first, g)
          s = Clojure.next(s)
          s = Clojure.first(s) if Clojure.list?(Clojure.first(s))
          raise "expected a method" unless Clojure.count(s) >= 1
          m = Clojure.first(s)
          s = Clojure.next(s)
          c = 0
          until s.nil?
            compile(s.first, g)
            s = s.next
            c += 1
          end
          g.send m.name.to_sym, c, false
        else
          g.push_nil
        end
      end

      def compile_literal(exp, g)
        if Clojure.list?(exp)
          g.push_const :Clojure
          g.find_const :PersistentLinkedList
          g.push_const :Array
          c = 0
          s = Clojure.seq(exp)
          until s.nil?
            compile_literal(s.first, g)
            s = s.next
            c += 1
          end
          g.send :[], c, false
          g.send :create, 1, false
        else
          g.push_literal exp
        end
      end

      def eval(exp)
        g = Rubinius::ToolSet::Runtime::Generator.new
        compile(exp, g)
        g.ret
        g.encode
        Rubinius.run_script(g.package(Rubinius::CompiledCode))
      end
    end
  end
end
