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
