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
  class Reader
    EOF = Object.new

    def initialize(io)
      @io = io
    end

    def readchar
      @io.readchar
    rescue EOFError
      EOF
    end

    def unreadchar(c)
      @io.ungetc(c) unless c == EOF
    end

    def peekchar
      c = readchar
      unreadchar(c)
      c
    end

    def consume_whitespace
      c = readchar
      while c =~ /[\s,]/
        c = readchar
      end
      unreadchar(c)
    end

    def delimiter?(c)
      c =~ /[\s,()\[\]{}#]/ || c == EOF
    end

    def read
      consume_whitespace
      c = peekchar
      case c
      when /[+-]/
        c = readchar
        c2 = peekchar
        unreadchar(c)
        if c2 =~ /[0-9]/
          read_number
        else
          read_symbol
        end
      when /[0-9]/
        read_number
      when '('
        read_list
      when '['
        read_vector
      when '{'
        read_map
      when '#'
        readchar
        c = peekchar
        case c
        when '{'
          read_set
        end
      else
        read_symbol
      end
    end

    def read_symbol
      c = readchar
      sym = ""
      until delimiter?(c) || c == '/'
        sym << c
        c = readchar
      end
      if c == '/'
        namespace = sym
        sym = ""
        c = readchar
        until delimiter?(c)
          sym << c
          c = readchar
        end
        unreadchar(c)
        Symbol.create(namespace, sym)
      else
        unreadchar(c)
        Symbol.create(sym)
      end
    end

    def read_number
      c = readchar
      raise "expected number" unless c =~ /[0-9+-]/
      num = c
      c = readchar
      until delimiter?(c)
        num << c
        c = readchar
      end
      unreadchar(c)
      case num
      when /\A[-+]?[0-9]+[Nn]?\z/
        if num.end_with?('N')
          num.chomp.to_i
        else
          num.to_i
        end
      when /\A[-+]?[0-9]+\/[0-9]+\z/
        num.to_r
      when /\A[-+]?[0-9]+(?:\.[0-9]+(?:[Ee][-+]?[0-9]+)?)?[Mm]?\z/
        if num.end_with?('M')
          num.chomp.to_d
        else
          num.to_f
        end
      else
        raise "invalid number #{num}"
      end
    end

    def read_list
      c = readchar
      raise "expected list" unless c == '('
      list = PersistentLinkedList::EMPTY
      until peekchar == ')' || peekchar == EOF
        list = list.conj(read)
      end
      raise "expected )" unless peekchar == ')'
      readchar
      new_list = PersistentLinkedList::EMPTY
      s = list.seq
      until s.nil?
        new_list = new_list.conj(s.first)
        s = s.next
      end
      new_list
    end

    def read_vector
      c = readchar
      raise "expected vector" unless c == '['
      vec = PersistentArrayVector::EMPTY
      until peekchar == ']' || peekchar == EOF
        vec = vec.conj(read)
      end
      raise "expected ]" unless peekchar == ']'
      readchar
      vec
    end

    def read_set
      c = readchar
      raise "expected set" unless c == '{'
      set = PersistentArraySet::EMPTY
      until peekchar == '}' || peekchar == EOF
        set = set.conj(read)
      end
      raise "expected }" unless peekchar == '}'
      readchar
      set
    end

    def read_map
      c = readchar
      raise "expected map" unless c == '{'
      map = PersistentArrayMap::EMPTY
      until peekchar == '}' || peekchar == EOF
        k = read
        if peekchar != '}' && peekchar != EOF
          v = read
          map = map.conj([k, v])
        else
          raise "expected value for key #{k}"
        end
      end
      raise "expected }" unless peekchar == '}'
      readchar
      map
    end
  end
end
