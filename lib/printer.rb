# frozen_string_literal: true

# This class walks through the payload object and
# builds a prettified representation in rswag format.
class SwaggerPrinter
  class << self
    def print_swagger(object, test_title)
      @indent ||= 2
      line = "#{test_title}: {\n"
      line += print_values(object)
      line + end_wrap
    end

    def wrap_hash
      line  = ' ' * @indent + "type: :object,\n"
      line += ' ' * @indent + "properties: {\n"
      @indent += 2
      line
    end

    def wrap_array
      line  = ' ' * @indent + "type: :array,\n"
      line += ' ' * @indent + "items: {\n"
      @indent += 2
      line
    end

    def end_wrap
      line = ''
      while @indent > 2
        @indent -= 2
        line += ' ' * @indent + "}\n"
      end
      line + '}'
    end

    def print_values(object)
      return wrap_array + print_values(object.first) if object.is_a?(Array)

      output = wrap_hash
      object.each_with_index do |(key, val), i|
        line = if val[:type] == :object
                 print_hash(key, val)
               elsif val[:type] == :array
                 print_array(key, val)
               else
                 print_line(key, val)
               end
        comma = i == object.keys.size - 1 ? '' : ','
        line += "#{comma}\n"
        output += line
      end
      output
    end

    def print_hash(key, val)
      line = ' ' * @indent + "#{key}: {\n"
      @indent += 2
      line += print_values(val[:properties])
      @indent -= 2
      line += ' ' * @indent + "}\n"
      @indent -= 2
      line += ' ' * @indent + '}'
      line
    end

    def print_array(key, val)
      line = ' ' * @indent + "#{key}: {\n"
      @indent += 2
      line += wrap_array
      line += print_values(val[:items].first)
      @indent -= 2
      line += ' ' * @indent + "}\n"
      @indent -= 2
      line += ' ' * @indent + '}'
      line
    end

    def print_line(key, val)
      line = ' ' * @indent + "#{key}: { "
      val.each_with_index do |(val_key, val_val), j|
        next if val_key == :type && val.any? { |k, v| k == :example && v == nil }
        val_comma = j == val.keys.size - 1 ? '' : ','
        line += "#{escape_key(val_key)}: #{prettify_value(val, val_key, val_val)}#{val_comma} "
      end
      line + '}'
    end

    def escape_key(key)
      return key unless key.to_s.include?('-')
      
      "'#{key.to_s}'"
    end

    def prettify_value(type, key, val)
      return ':' + val.to_s if key == :type
      return val if key != :example
      return 'nil' if val.nil?

      type[:type] == :string ? "'#{val}'" : val
    end
  end
end
