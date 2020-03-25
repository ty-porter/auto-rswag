# frozen_string_literal: true

require 'json'
require 'printer.rb'
require 'auto_rswag_helper.rb'
require 'doc_writer.rb'

# This module hooks into the Rspec test to retrieve useful
# metadata and submit it to AutoRswagHelper for conversion.
module AutoRswag
  def update_documentation
    after do |example|
      title = example.metadata[:response][:schema]['$ref'].split('/').last
      payload = AutoRswagHelper.convert_response(response)
      AutoRswagHelper.map_fields(payload)
      docs = SwaggerPrinter.print_swagger(payload, title)
      DocWriter.new(example.metadata).write_docs(docs, title)
    end
  end
end

Rswag::Specs::ExampleGroupHelpers.module_eval do
  include AutoRswag
end