ISO Schematron
==============

Ruby gem for validating XML against schematron schema

Uses [ISO Schematron](http://www.schematron.com) version: 2010-01-25

Installation
------------

    % gem install schematron-nokogiri

Command line example
-------------------

    % stron-nokogiri my_schema.stron my_xml_document.xml

Ruby API example
----------------

    # overhead
    require "nokogiri"
    require "schematron"
      
    # load the schematron xml
    stron_doc = Nokogiri::XML File.open "/path/to/my_schema.stron"
    
    # make a schematron object
    stron = SchematronNokogiri::Schema.new stron_doc
    
    # load the xml document you wish to validate
    xml_doc = Nokogiri::XML File.open "/path/to/my_xml_document.xml"
    
    # validate it
    results = stron.validate xml_doc
    
    # print out the results
    stron.validate(instance_doc).each do |error|
      puts "#{error[:line]}: #{error[:message]}"
    end
    
---
This gem replaces the libxml and libxslt-ruby with Nokogiri in the gem https://github.com/flazz/schematron
The replacement was done by Alexandru Szasz at https://github.com/alexxed/schematron
Copyright © 2009-2010 [Francesco Lazzarino](mailto:flazzarino@gmail.com).

Sponsored by [Florida Center for Library Automation](http://www.fcla.edu).

See LICENSE.txt for terms.
