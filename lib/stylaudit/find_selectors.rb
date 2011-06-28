class FindSelectors
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
      pcc = PickCssSelectors.new(f)
      css_classes_in_templates[f] = pcc.classes
    end

    map_hash = {}
    css_class_hash.each do |file, classes_array| # For each css file
      c_h = {}
      classes_array.each do |css_class| # For each css class present in one file
        class_hash = {}
        css_classes_in_templates.each do |template_file, used_class_hash| # For each css classes in the template file
          used_class_hash.each do |ref_type, css_ref_name_array| # for each ref type
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

