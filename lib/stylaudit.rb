require 'rubygems'
require 'css_parser'
require 'pp'
require './stylaudit/find_classes'
require './stylaudit/pick_css_classes'
require './stylaudit/util'
require './stylaudit/find_files'
require './stylaudit/abstract_printer'
require './stylaudit/flat_printer'
require './stylaudit/html_printer'

include CssParser

$rails_root = ARGV[0]

FlatPrinter.new(FindClasses.new.map_hash, :file_name => "hola1.out").print

