Script "stack_SvgIconTool_widget_id_1185"

/*
# Name: widget "TopLevelStack" of card "settings" of stack "SvgIconTool"
# ID: widget id 1185 of card id 1007 of stack "SvgIconTool"
# Widget Kind: com.livecode.widget.svgpath
# Behavior: button id 1024 of stack "SvgIconTool"
*/


on mouseUp
   topLevel this stack
end mouseUp

on mouseDoubleUp
   palette this stack
end mouseDoubleUp

/* Clean stack for posting:
Go card "grid"
topLevel stack "SvgIconTool"
clearData

save stack

Extra stuff:
set the style of stack "SvgIconTool" to "palette"
set the style of stack "SvgIconTool" to "toplevel"
*/
