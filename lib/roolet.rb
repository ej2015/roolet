require "roolet/version"
require 'roo'
require 'forwardable'
require 'roolet/excelx'

module Roolet

	extend Forwardable
	extend self

  def_delegator Roolet::Excelx, :new


end
