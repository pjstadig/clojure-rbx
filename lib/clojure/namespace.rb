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
  class Namespace
    class << self
      @@namespaces = Atomic.new(PersistentArrayMap::EMPTY)

      def exists?(name)
        @@namespaces.get.include?(name)
      end

      def intern(name)
        if !exists?(name)
          @@namespaces.update do |namespaces|
            if !namespaces.include?(name)
              namespaces.put(name, Namespace.new(name))
            else
              namespaces
            end
          end
        end
        resolve(name)
      end

      def resolve(name)
        raise "expected string" unless name.is_a?(String)
        raise "cannot resolve #{name}" unless exists?(name)
        @@namespaces.get.val_at(name)
      end
    end

    def initialize(name)
      raise "invalid namespace" unless name =~ Symbol::NAMESPACE_REGEX
      @name = name
      @vars = Atomic.new(PersistentArrayMap::EMPTY)
    end

    def exists?(name)
      @vars.get.include?(name)
    end

    def intern(name, value = Var::UNBOUND)
      if !exists?(name)
        @vars.update do |vars|
          if !vars.include?(name)
            vars.put(name, Var.new(name, value))
          end
        end
      end
      resolve(name)
    end

    def resolve(name)
      raise "expected string" unless name.is_a?(String)
      raise "cannot resolve #{name}" unless exists?(name)
      @vars.get.val_at(name)
    end
  end
end
