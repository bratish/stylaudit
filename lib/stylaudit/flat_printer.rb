class FlatPrinter < AbstractPrinter

  def print
    file = 'map.out'
    file = @options[:file_name] if @options[:file_name]
    p file
    f = File.new(file, 'w')
    @result.each do |css_file, hsh|
      f.puts("#{" " * 0}CSS File: #{css_file}")
      hsh.each do |identifier, references|
        if references.empty?
          f.puts("#{" " * 2}Identifier '#{identifier}' is never used.")
        else
          f.puts("#{" " * 2}Identifier '#{identifier}' is used in these following files:")
          references.each do |ref_type, f_array|
            case ref_type
            when "clean_class_references"
              f.puts("#{" " * 4}Cleanly found in these following files:")
            when "class_references_inside_script_tags"
              f.puts("#{" " * 4}Identifiers found inside script tags in these following files:")
            when "partial_class_references"
              f.puts("#{" " * 4}Following identifiers found in partially in these following files:")
            end
            f_array.each {|template_file| f.puts("#{" " * 6}#{template_file}")}            
          end
        end
      end
    end
    f.close
  end
end
