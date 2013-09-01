#
# repeated_param.rb
#
require 'puppet/parser/functions'

module Puppet::Parser::Functions
  newfunction(:repeated_param, :type => :rvalue, :doc => <<-DOC) do |args|
Joins parameters together with " " on a specific flag.

Exmaple:

  repeated_param('tag', ['a', 'b', 'c'])
  => '--tag a --tag b --tag c'

  DOC

    if args[0].is_a? Array
      args = args[0]
    end

    raise(Puppet::ParseError, "repeated_param/2: Wrong number of arguments " +
          "given (#{args.size} instead of 2.)") unless args.size == 2

    raise(Puppet::ParseError, "repeated_param/2: Second argument " +
          "must have #map") unless args[1].respond_to?(:map)

    flag = args[0]
    vals = args[1]

    vals.map { |i| "--#{flag} #{i}" }.join(' ')
  end
end