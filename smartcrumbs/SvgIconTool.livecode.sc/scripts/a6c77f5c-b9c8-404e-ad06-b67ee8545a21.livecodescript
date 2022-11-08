on dragEnter
   local tFamilyPath

   set the dragAction to "copy"
   put line 1 of the dragdata["files"] into tFamilyPath

   if tFamilyPath is empty then exit to top

   loadIconFamily tFamilyPath
end dragEnter

on loadIconFamily pFamilyPath
   local tIconFileName, tIconName, tFileList, tFileText, tPath

   set itemdel to "/"
   if there is a file pFamilyPath then
      put pFamilyPath into tIconFileName
      put item 1 to - 2 of tIconFileName into pFamilyPath
   end if

   put files(pFamilyPath) into tFileList

   if tIconFileName is empty then
      put pFamilyPath & "/" & line 1 of tFileList into tIconFileName
   end if

   set linedel to "/"
   set itemdel to "."
   put item 1 to - 2 of line - 1 of tIconFileName into tIconName

   put tFileList into field"FileList"
   put pFamilyPath into field"FilePath"

   set linedel to return
   select line the lineoffset(tIconName & ".", field"FileList") of field"FileList"
   send "selectionChanged" to field"FileList"
end loadIconFamily

on preOpenCard
   lock screen
   set the hilitedItemName of widget"NavBar" to the short name of this card
   select line the lineoffset(field "IconName" of card"icon" & ".", \
         field"FileList") of field"FileList"
   send "selectionChanged" to field"FileList"
   revUpdateGeometry
   unlock screen
end preOpenCard

on selectFolderToOpen
   local tIconFilePath

   answer folder "Select an icon SVG folder to load:"

   if the result is "Cancel" then
      exit to top
   end if

   put it into tIconFilePath

   if there is a folder tIconFilePath then
      loadIconFamily tIconFilePath
   end if
end selectFolderToOpen