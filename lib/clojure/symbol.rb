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
  class Symbol
    NAMESPACE_REGEX = /\A[^\/\s0-9][^\/\s]*\z/
    NAME_REGEX = /\A[^\s0-9][^\s]*\z/

    class << self
      private :new

      def create(*args)
        namespace, name = *args
        namespace, name = nil, namespace if name.nil?
        if namespace && namespace !~ NAMESPACE_REGEX
          raise ArgumentError, "invalid namespace #{namespace}"
        end
        if name !~ NAME_REGEX
          raise ArgumentError, "invalid name #{name}"
        end
        new(namespace && namespace.dup, name.dup).freeze
      end
    end

    attr_reader :namespace, :name

    def initialize(namespace, name)
      @namespace = namespace && namespace.freeze
      @name = name.freeze
    end

    def ==(obj)
      obj.is_a?(Symbol) && @namespace == obj.namespace && @name == obj.name
    end

    def to_s
      if namespace
        "#{namespace}/#{name}"
      else
        name
      end
    end
  end
end
