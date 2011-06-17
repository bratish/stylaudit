require 'rubygems'
require 'css_parser'
require 'pp'
require './stylaudit/find_selectors'
require './stylaudit/pick_css_selectors'
require './stylaudit/util'
require './stylaudit/find_files'
require './stylaudit/abstract_printer'
require './stylaudit/flat_printer'
require './stylaudit/html_printer'

include CssParser

$rails_root = ARGV[0]

FlatPrinter.new(FindSelectors.new.map_hash, :file_name => "hola1.out").print

