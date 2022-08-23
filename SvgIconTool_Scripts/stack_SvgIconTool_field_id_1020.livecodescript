Script "stack_SvgIconTool_field_id_1020"

/*
# Name: field "FileList" of card "family" of stack "SvgIconTool"
# ID: field id 1020 of card id 1003 of stack "SvgIconTool"
*/


on selectionChanged
   local tIconFileName, tIconName, tPath, tFileText
   put field "FilePath" & "/" & the selectedText into tIconFileName
   set linedel to "/"
   set itemdel to "."
   put item 1 to -2 of line -1 of tIconFileName into tIconName
   put tIconName into field "IconName" of card "icon"
   put line -2 of tIconFileName & "/" before tIconName
   put tIconName into field "IconName"
   put url ("file:" & tIconFileName) into tFileText
   put extractPathFromSvg(tFileText) into tPath
   
   try
      set the iconPath of widget "SVG_Icon" to tPath
   catch tError
      answer "Error setting path for " & tIconName & cr & tError
   end try
   
   put tIconFileName into field "FileName" of card "icon"
   put tFileText into field "FileText" of card "icon"
   put tPath into field "Path" of card "icon"
   try
      set the iconPath of widget "SVG_Icon" of card "icon" to tPath
   end try
end selectionChanged
