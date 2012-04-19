require 'ripper'

require 'ruby-debug19'

$: << '.'

require 'util/track_subclasses'
require 'core_ext/string'

require 'node'

module Magnolia
  def self.parse(input)
    case input
    when String
      parse(Ripper.sexp(input))
    else
      Node::Expression.build_subtype(input)
    end
  end
end
