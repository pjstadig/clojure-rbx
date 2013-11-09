# -*- coding: utf-8 -*-
# Copyright © 2013 Paul Stadig. All rights reserved.
#
# The use and distribution terms for this software are covered by the Eclipse
# Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html) the text of
# which can be found in the file epl-v10.txt at the root of this distribution.
# By using this software in any fashion, you are agreeing to be bound by the
# terms of this license.  You must not remove this notice, or any other, from
# this software.
require 'clojure/persistent_collection'

module Clojure
  module PersistentStack
    include PersistentCollection

    # def conj(obj); raise; end
    # def count; raise; end
    # def empty; raise; end
    # def equiv(obj); raise; end
    # def peek(); raise; end
    # def pop(); raise; end
    # def seq; raise; end
  end
end
