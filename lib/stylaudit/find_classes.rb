#rails_root = "/Users/bratish/p/solaro_copy"
#rails_root = "/home/bratish/gnimmargorp/solaro-projects/solaro_old"
class FindClasses
  def map_hash
    css_class_hash = {}
    ff = FindFiles.new($rails_root)

    ff.css_files.each do |f|
      parser = CssParser::Parser.new
      parser.load_file!(f)
      array_of_classes = []

      parser.each_selector do |selector, declarations, specificity|
        array_of_classes.push(selector) if selector.include? "."
      end
      css_class_hash[f] = array_of_classes.collect{|x| x.scan(/\.([\w\-]+)/)}.flatten.uniq
    end

    css_classes_in_templates = {}
    ff.template_files.each do |f|
      pcc = PickCssClasses.new(f)
      pcc.classes
      css_classes_in_templates[f] = {
    "clean_class_references"              => pcc.pure_class_references,
    "class_references_inside_script_tags" => pcc.dynamic_class_references,
    "partial_class_references"            => pcc.partial_class_references
      }
    end

    map_hash = {}
    css_class_hash.each do |file, classes_array| # For each css file
#      p file
      c_h = {}
      classes_array.each do |css_class| # For each css class present in one file
        class_hash = {}
        css_classes_in_templates.each do |template_file, used_class_hash| # For each css classes in the template file
#          p template_file
          used_class_hash.each do |ref_type, css_ref_name_array| # for each ref type
#            p ref_type
#            p css_ref_name_array
            if ref_type == "partial_class_references" && css_ref_name_array.size > 0
              css_class_array = Util.underscore(css_class).split(/[-_]/)
              css_class_array.each do |syllable| 
                if css_ref_name_array.include?(syllable)
                  class_hash.include?(ref_type)? (class_hash[ref_type].push(template_file)) : (class_hash[ref_type] = [template_file])  
                end
              end
            else
              if css_ref_name_array.include? css_class
                class_hash.include?(ref_type)? (class_hash[ref_type].push(template_file)) : (class_hash[ref_type] = [template_file])
              end
            end
          end
        end
        c_h[css_class] = class_hash
      end
      map_hash[file] = c_h
    end
    map_hash
  end
end
#FlatPrinter.new(map_hash, :file_name => "hola1.out").print
#HTMLPrinter.new(map_hash).print

