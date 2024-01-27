# Hamilton (Franklin) Book Theme 

by Bryan Braun

See a live version @ [`bookdesigns.github.io/book-hamilton` »](http://bookdesigns.github.io/book-hamilton)

## Sources

What's Franklin?

> Franklin is a static-site framework, optimized for online books.

See the Hamilton theme in the Franklin repo @ [`/franklin/themes/hamilton` »](https://github.com/bryanbraun/franklin/tree/master/source/themes/hamilton)

See the Hamilton sample book in the bitbooks archive @ [`bitbooks.github.io/example-book-hamilton` »](http://bitbooks.github.io/example-book-hamilton).




## Update & Build Notes


### Changes

- Removed Happy Browsing Banner
- Removed Internet Explorer (IE) Conditionals



### Syntax Highlighting

Generate syntax.css theme using Rouge

```
<%# A good day theme, though not that colorful %>
<%#= Rouge::Themes::Github.render(:scope => '.highlight') %>

<%# A good day theme, and is very colorful %>
<%= Rouge::Themes::Base16.render(:scope => '.highlight') %>

<%# That good sublime text night theme%>
<%#= Rouge::Themes::Base16::Monokai.render(:scope => '.highlight') %>
```



