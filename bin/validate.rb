#!/usr/bin/ruby

require 'libxml'
require 'libxslt'

include LibXML
include LibXSLT

# The location of the ISO schematron implemtation lives
ISO_IMPL_DIR = 'iso_impl'

# The file names of the compilation stages
ISO_FILES = [ 'iso_dsdl_include.xsl',
              'iso_abstract_expand.xsl',
              'iso_svrl.xsl' ]

# Namespace prefix declarations for use in XPaths
NS_PREFIXES = { 
  'svrl' => 'http://purl.oclc.org/dsdl/svrl' 
}

# Tell the parse to remember the line numbers for each node
XML::Parser::default_line_numbers = true

# Get sch and xml from command line
schema_doc = XML::Document.file ARGV[0]
instance_doc = XML::Document.file ARGV[1]

# Compile schematron into xsl that maps to svrl
xforms = ISO_FILES.map do |file|

  Dir.chdir(ISO_IMPL_DIR) do
    doc = XML::Document.file file
    XSLT::Stylesheet.new doc
  end

end

validator_doc = xforms.inject(schema_doc) { |xml, xsl| xsl.apply xml }
validator_xsl = XSLT::Stylesheet.new validator_doc

# Validate the xml
results_doc = validator_xsl.apply instance_doc

# Print the errors
results_doc.root.find('//svrl:failed-assert', NS_PREFIXES).each do |assert|
  context = instance_doc.root.find_first assert['location']

  assert.find('svrl:text/text()', NS_PREFIXES).each do |message|
    puts '%s "%s" on line %d: %s' % [ context.node_type_name,
                                      context.name, 
                                      context.line_num,
                                      message.content.strip ]
  end

end
