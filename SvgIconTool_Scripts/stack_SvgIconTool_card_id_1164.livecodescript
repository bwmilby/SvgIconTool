Script "stack_SvgIconTool_card_id_1164"

/*
# Name: card "library" of stack "SvgIconTool"
# ID: card id 1164 of stack "SvgIconTool"
*/


local sIconData

on preOpenCard
   revUpdateGeometry
   set the hilitedItemName of widget "NavBar" to the short name of this card
   
   put the uIconData of card "grid" into sIconData
   populateFields
end preOpenCard

on mouseUp pButtonNumber
   local tTool, tLibrary
   put line (the hilitedline of field "ToolList") of field "ToolList" into tTool
   put line (the hilitedline of field "LibraryList") of field "LibraryList" into tLibrary
   set itemdel to quote
   try
      switch item 2 of the target
         case "ImportToolFamily"
            answer file "Select an icon data file to import:"
            if the result is not "Cancel" and there is a file it then
               set the linedel to "/"
               set the itemdel to "."
               put arrayDecode(URL ("binfile:" & it)) into sIconData[item 1 of line -1 of it]
               set the uIconData of card "grid" to sIconData
               populateFields
            end if
            break
         case "ExportToolFamily"
            ask file "Select where to save the data:" with tTool & ".lson"
            if the result is not "Cancel" then
               put arrayEncode(sIconData[tTool]) into URL ("binfile:" & it)
            end if
            break
         case "DeleteToolFamily"
            delete variable sIconData[tTool]
            set the uIconData of card "grid" to sIconData
            populateFields
            break
         case "CopyToolToLibrary"
            addIconFamily tTool, sIconData[tTool]
            populateFields
            break
         case "CopyLibraryToTool"
            put iconDataForFamily(tLibrary) into sIconData[tLibrary]
            set the uIconData of card "grid" to sIconData
            populateFields
            break
         case "DeleteLibraryFamily"
            deleteIconFamily tLibrary
            populateFields
            break
         case "SetCurrentLibrary"
            setCurrentIconFamily tLibrary
            populateFields
            break
      end switch
   catch e
      answer "Some error occurred:  " & e
   end try
end mouseUp

command populateFields
   lock screen
   local tList
   put the keys of sIconData into tList
   sort tList
   put tList into field "ToolList"
   try
      put iconFamilies() into tList
      sort tList
      put tList into field "LibraryList"
      put getCurrentIconFamily() into field "CurrentFamily"
   end try
   set the hilitedline of field "ToolList" to 1
   set the hilitedline of field "LibraryList" to 1
   unlock screen
end populateFields

on dragEnter
   set the dragAction to "copy"
end dragEnter

on dragDrop
   local tFamilyFiles, tIconName, tFileText, tPath
   
   put the dragdata["files"] into tFamilyFiles
   
   if tFamilyFiles is empty then exit to top
   
   loadFamilies tFamilyFiles
   populateFields
end dragDrop

on loadFamilies pFamilyFiles
   repeat for each line tFile in pFamilyFiles
      if there is a file tFile then
         set the linedel to "/"
         set the itemdel to "."
         put arrayDecode(URL ("binfile:" & tFile)) into sIconData[item 1 of line -1 of tFile]
         set the uIconData of card "grid" to sIconData
         set the linedel to cr
      else if there is a folder tFile then
         if tFile begins with "." then next repeat
         loadFamilies files(tFile)
      end if
   end repeat
end loadFamilies
