# frozen_string_literal: true

# This class writes the parsed documenation to the swagger_helper file.
class DocWriter
  class << self
    def default_docs_path
      Rails.root.join('spec', 'swagger_helper.rb').to_s
    end

    def write_docs(docs, fragment_title)
      old_documentation = File.read(default_docs_path)
      old_documentation_fragment = example_hash(fragment_title, old_documentation)
      return if old_documentation_fragment.nil?

      new_documentation_fragment = apply_original_indentation(docs, fragment_title)
      new_documentation = old_documentation.sub(old_documentation_fragment, new_documentation_fragment)
      File.open(default_docs_path, 'w') { |f| f.write(new_documentation) }
    end

    def example_hash(fragment_title, old_documentation)
      match = ''
      iterator = 1
      while true do
        regex = /(#{fragment_title})(.*?\}){#{iterator}}/
        new_match_data = old_documentation.match(regex)
        new_match = new_match_data.present? ? new_match_data[0] : nil
        return unless new_match != match

        match = new_match
        begin
          return match if eval("{#{match}}")
        rescue SyntaxError
        end

        iterator += 1
      end
    end

    def apply_original_indentation(new_documentation, fragment_title)
      indentation = ' ' * original_indent_level(fragment_title)
      new_documentation.split("\n").join("\n" + indentation)
    end

    def original_indent_level(fragment_title)
      file = File.read(default_docs_path)
      file.match(/\s+(?=#{fragment_title})/)[0].size - 1
    end
  end
end
