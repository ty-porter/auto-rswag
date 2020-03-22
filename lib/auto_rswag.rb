# frozen_string_literal: true

require 'json'
require_relative 'printer.rb'
require_relative 'auto_rswag_helper.rb'
require_relative 'doc_writer.rb'

# This module hooks into the Rspec test to retrieve useful
# metadata and submit it to AutoRswagHelper for conversion.
module AutoRswag
  def update_documentation
    $title = metadata[:response][:schema]['$ref'].split('/').last

    after do
      payload = AutoRswagHelper.convert_response(response)
      AutoRswagHelper.map_fields(payload)
      docs = SwaggerPrinter.print_swagger(payload, $title)
      DocWriter.write_docs(docs, $title)
    end
  end
end
