class FlatPrinter < AbstractPrinter

  def print
    file = 'map.out'
    file = @options[:file_name] if @options[:file_name]
    f = File.new(file, 'w')
    @result.each do |css_file, hsh|
      f.puts("\n\n#{" " * 0}CSS File: #{css_file}")
      neve_used_list = []
      hsh.each do |identifier, references|
        if references.empty?          
          neve_used_list.push(identifier)
        else
          f.puts("\n#{" " * 2}Identifier '#{identifier}' is used in these following files:")
          references.each do |ref_type, f_array|
            case ref_type
            when "clean_class_references"
              f.puts("\n#{" " * 4}CLEANLY found in these following files:")
            when "class_references_inside_script_tags"
              f.puts("\n#{" " * 4}Identifiers found INSIDE SCRIPT TAGS in these following files:")
            when "partial_class_references"
              f.puts("\n#{" " * 4}Following identifiers found PARTIALLY in these following files:")
            end
            f_array.each {|template_file| f.puts("#{" " * 6}#{template_file}")}            
          end
        end
      end
      f.print("\n#{" " * 2}Following identifiers are never used:\n#{" " * 6}")
      neve_used_list.each_with_index do |identifier, i| 
        f.print(identifier)
        f.print((((i + 1) % 5) == 0)? "\n#{" " * 6}" : ", ")
      end
    end
    f.close
    puts "Output written in #{file}"
  end
end
