on dragEnter
   local tIconFileName, tIconName, tFileText, tPath

   set the dragAction to "copy"
   put line 1 of the dragdata["files"] into tIconFileName

   if tIconFileName is empty then exit to top

   loadIconFile tIconFileName
end dragEnter

on loadIconFile pIconFileName
   local tIconName, tFileText, tPath, tError

   set linedel to "/"
   set itemdel to "."
   put item 1 to - 2 of line - 1 of pIconFileName into tIconName

   put url ("file:" & pIconFileName) into tFileText

   put extractPathFromSvg(tFileText) into tPath

   try
      set the iconPath of widget"SVG_Icon" to tPath
   catch tError
      answer "Error setting path for " & tIconName & cr & tError
   end try

   put pIconFileName into field"FileName"
   put tIconName into field"IconName"
   put tFileText into field"FileText"
   put tPath into field"Path"
end loadIconFile

on preOpenCard
   set the hilitedItemName of widget"NavBar" to the short name of this card
   revUpdateGeometry
end preOpenCard

on selectFileToOpen
   local tIconFileName

   answer file "Select an icon SVG file to load:"

   if the result is "Cancel" then
      exit to top
   end if

   put it into tIconFileName

   if there is a file tIconFileName then
      loadIconFile tIconFileName
   end if
end selectFileToOpen