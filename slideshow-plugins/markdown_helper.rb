module MarkdownHelper
  
  # helper/shortcut for adding embedded image to slide in markdown syntax:
  #  ![alt text](/path/to/img.jpg "Title")
  #
  #  use it like:
  #  <%= image 'friendsbadge.png' %>
  #
  #  note: alternate text (alt) and title are optional
  
  def image( path, alt="", title="" )
    %Q{![#{alt}](#{path} "#{title}")} 
  end
  
end

Slideshow::Gen.__send__( :include, MarkdownHelper )

