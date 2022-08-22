Script "stack_SvgIconTool_"

/*
# Name: stack "SvgIconTool"
# ID: stack "SvgIconTool"
*/


function extractPathFromSvg pSVG
   local tPath, tIndex, tLine
   
   set linedel to " d="
   set itemdel to quote
   put 0 into tIndex
   repeat for each line tLine in pSVG
      add 1 to tIndex
      if tIndex is 1 then next repeat
      put item 2 of tLine after tPath
   end repeat
   return tPath
end extractPathFromSvg

on openStack
   if the hilite of button "ShowHelp" of card "settings" of me then
      go card "settings"
   end if
end openStack
