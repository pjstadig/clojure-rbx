# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'clojure-rbx'

class MiniTest::Unit::TestCase
end

class ClojureTestCase < MiniTest::Unit::TestCase
  def vector(values)
    Clojure::PersistentArrayVector.create(values)
  end

  def map(values)
    Clojure::PersistentArrayMap.create(values)
  end

  def set(values)
    Clojure::PersistentArraySet.create(values)
  end

  def list(values)
    Clojure::PersistentLinkedList.create(values)
  end
end

MiniTest::Unit.autorun
