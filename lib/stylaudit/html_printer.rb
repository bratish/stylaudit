class HTMLPrinter < AbstractPrinter
  HTML_DOC_FIRST_PART =<<DOCFIRSTPART
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
  <meta name="description" content="description"/>
  <meta name="keywords" content="keywords"/> 
  <meta name="author" content="Bratish Goswami"/> 
  <link rel="stylesheet" type="text/css" href="default.css" media="screen"/>
  <title>CSS Auditor</title>
  <script type="text/javascript" src="jquery-1.6.min.js"></script>
</head>
<body>

<div class="container">
	<div class="navigation">
		<div class="title">
			<h1>CSS Auditor</h1>
			<h2>- Find CSS attributes in your project -</h2>
		</div>
	</div>

	

	<div class="holder">
  <div class="msg_list">
DOCFIRSTPART

  HTML_DOC_SECOND_PART =<<DOCSECONDPART
	
		</div>
	<br />

 </div>

	<div class="footer">&copy; 2006 <a href="index.html">Website.com</a>. Valid <a href="http://jigsaw.w3.org/css-validator/check/referer">CSS</a> &amp; <a href="http://validator.w3.org/check?uri=referer">XHTML</a>. Template design by <a href="http://templates.arcsin.se">Arcsin</a>
	</div>

</div>

<script type="text/javascript" src="jquery.js"></script>
<script type="text/javascript">
$(document).ready(function()
{
  //hide the all of the element with class msg_body
  $(".msg_body").hide();
  //toggle the componenet with class msg_body
  $(".msg_head").click(function()
  {
    $(this).next(".msg_body").slideToggle(600);
  });
});
</script>
</body>
</html>

DOCSECONDPART

  def print
    file = 'map.html'
    file = @options[:file_name] if @options[:file_name]
    f = File.new(file, 'w')
    f.puts(HTML_DOC_FIRST_PART)
    @result.each do |css_file, hsh|
      f.puts("<p class='msg_head'>CSS File: #{css_file}</p><div class='msg_body'>")
      not_used_identifiers = []
      hsh.each do |identifier, references|
        if references.empty?
          not_used_identifiers.push(identifier)
        else
          f.puts("<p class='msg_head'>Identifier '#{identifier}' is used in these following files:</p><div class='msg_body'>")
          references.each do |ref_type, f_array|
            case ref_type
            when "clean_class_references"
              f.puts("<p class='msg_head greenDiv'>Cleanly found in these following files:</p>")
            when "class_references_inside_script_tags"
              f.puts("<p class='msg_head yellowDiv'>Identifiers found inside script tags in these following files:</p>")
            when "partial_class_references redDiv"
              f.puts("<p class='msg_head'>Following identifiers found in partially in these following files:</p>")
            end
            f.puts("<div class='msg_body'>")
            f_array.each {|template_file| f.puts("#{template_file}<br />")}
            f.puts("</div>")
          end
          f.puts("</div>")
        end
      end
      # Print which are not used
      f.puts("<p class='msg_head paleDiv'>Identifiers that are never used.</p><div class='msg_body'>#{not_used_identifiers.join(" ")}</div>") if not_used_identifiers.size > 0
      
      f.puts("</div>")
    end
    f.puts(HTML_DOC_SECOND_PART)
    f.close
  end

end
