local sIconData, sIconPage, sIconCount, sIconList, sFamily, sAddFamily
constant kCols = 10
constant kRows = 8

on preOpenCard
   revUpdateGeometry
   local tFamilies, tLine
   set the hilitedItemName of widget"NavBar" to the short name of this card

   put the hilite of button"AddFamily" of card"settings" into sAddFamily

   put getIconData() into sIconData

   put the keys of sIconData into tFamilies

   set itemdel to "/"
   put item - 2 of field"FileName" of card"icon" into sFamily
   if sFamily is not among the lines of tFamilies then
      importIconData
   end if

   iconFamilyChanged sFamily
end preOpenCard

command importIconData
   local tFamilyPath, tFamilyName, tFileList, tFileText, tPath, tIconName

   set itemdel to "/"
   put item 1 to - 2 of field"FileName" of card"icon" into tFamilyPath
   put item - 1 of tFamilyPath into tFamilyName
   put files(tFamilyPath) into tFileList
   repeat for each line tFile in tFileList
      put url ("file:" & tFamilyPath & "/" & tFile) into tFileText
      put extractPathFromSvg(tFileText) into tPath
      set itemdel to "."
      put item 1 to - 2 of tFile into tIconName
      put tPath into sIconData[tFamilyName][tIconName]["svg"]
      put 0 into sIconData[tFamilyName][tIconName]["codepoint"]
   end repeat
end importIconData

command iconFamilyChanged pFamily
   local tFamilies, tLine
   put pFamily into sFamily

   put the keys of sIconData into tFamilies
   if tFamilies is empty then
      set the text of button"FamilyMenu" to "no data"
   else
      sort tFamilies
      set the text of button"FamilyMenu" to tFamilies
      if sFamily is not among the lines of tFamilies then
         put line 1 of tFamilies into sFamily
      end if
   end if
   put the lineOffset(sFamily, tFamilies) into tLine
   set the menuHistory of button"FamilyMenu" to tLine

   put the keys of sIconData[sFamily] into sIconList
   sort sIconList
   put the number of lines of sIconList into sIconCount
   put 1 into sIconPage
   updateIcons
end iconFamilyChanged

command updateIcons
   local tOffset, tIconName, tPath, tObject, tSelected, tError, tErrors
   lock screen
   put (sIconPage - 1) * kRows * kCols into tOffset
   repeat with tRow = 1 to kRows
      repeat with tCol = 1 to kCols
         put line (tRow - 1) * kCols + tCol + tOffset of sIconList into tIconName
         put sIconData[sFamily][tIconName]["svg"] into tPath
         put sIconData[sFamily][tIconName]["selected"] is not empty into tSelected
         put "widget" && quote & "icon " & tCol & quote && "of group" && \
               quote & "row " & tRow & quote into tObject
         try
            set the iconPath of tObject to tPath
         catch tError
            put sFamily & "/" & tIconName & cr & tPath & cr & tError & cr & cr after tErrors
         end try
         set the toolTip of tObject to tIconName
         set the hilited of tObject to tSelected
         set the selected of tObject to tSelected
      end repeat
   end repeat
   unlock screen
   if tErrors is not empty then
      delete char - 2 to - 1 of tErrors
      answer "Errors setting icon paths:" & cr & cr & tErrors
   end if
end updateIcons

command goPrevPage
   if sIconPage > 1 then
      subtract 1 from sIconPage
      updateIcons
   end if
end goPrevPage

command goNextPage
   if sIconPage * kRows * kCols < sIconCount then
      add 1 to sIconPage
      updateIcons
   end if
end goNextPage

command goPrevFamily
   local tLine
   put the menuHistory of button"FamilyMenu" into tLine
   if tLine > 1 then
      subtract 1 from tLine
      set the menuHistory of button"FamilyMenu" to tLine
   end if
end goPrevFamily

command goNextFamily
   local tLine
   put the menuHistory of button"FamilyMenu" into tLine
   if tLine < the number of lines of the text of button"FamilyMenu" then
      add 1 to tLine
      set the menuHistory of button"FamilyMenu" to tLine
   end if
end goNextFamily

on arrowKey pKey
   switch pKey
      case "up"
         goPrevFamily
         break
      case "left"
         goPrevPage
         break
      case "down"
         goNextFamily
         break
      case "right"
         goNextPage
         break
   end switch
end arrowKey

command clearData
   local tObject
   --put empty into sIconData
   repeat with tRow = 1 to kRows
      repeat with tCol = 1 to kCols
         put "widget" && quote & "icon " & tCol & quote && "of group" && \
               quote & "row " & tRow & quote into tObject
         set the iconPath of tObject to empty
         set the toolTip of tObject to empty
      end repeat
   end repeat

   put empty into field"FileList" of card"family"
   put empty into field"FilePath" of card"family"
   put empty into field"IconName" of card"family"
   set the iconPath of widget"SVG_Icon" of card"family" to empty

   put empty into field"IconName" of card"icon"
   put empty into field"FileName" of card"icon"
   put empty into field"FileText" of card"icon"
   put empty into field"Path" of card"icon"
   set the iconPath of widget"SVG_Icon" of card"icon" to empty
end clearData

on mouseUp pButtonNumber
   local tIconName, tSelected
   if word 2 of the target begins with (quote & "icon") then -- click in icon
      put the toolTip of the target into tIconName
      put not the hilited of the target into tSelected
      set the selected of the target to tSelected
      if tSelected then
         put true into sIconData[sFamily][tIconName]["selected"]
      else
         delete variable sIconData[sFamily][tIconName]["selected"]
      end if
      set the hilited of the target to tSelected
   else
      set itemdel to quote
      switch item 2 of the target
         case "DeleteFamily"
            delete variable sIconData[sFamily]
            iconFamilyChanged sFamily
            break
         case "SaveFamily"
            setIconData sIconData
            ask file "Select where to save the data:" with sFamily & ".lson"
            if the result is not "Cancel" then
               put arrayEncode(sIconData[sFamily]) into URL ("binfile:" & it)
            end if
            break
         case "CopyIcons"
            ask "Enter a family name for the selected icons:"
            if the result is not "Cancel" and it is not empty then
               copyIconsToFamily it
            end if
            break
         case "SelectAll"
         repeat for each key tIconName in sIconData[sFamily]
            put true into sIconData[sFamily][tIconName]["selected"]
            end repeat
            updateIcons
            break
         case "SelectNone"
         repeat for each key tIconName in sIconData[sFamily]
            delete variable sIconData[sFamily][tIconName]["selected"]
            end repeat
            updateIcons
            break
      end switch
   end if
end mouseUp

on mouseDoubleUp pButtonNumber
   if word 2 of the target begins with (quote & "icon") then -- double click in icon
      copy the target
   end if
end mouseDoubleUp

on copyIconsToFamily pNewFamily
   local tNewIconName
   repeat for each key tIconName in sIconData[sFamily]
      if sIconData[sFamily][tIconName]["selected"] then
         put tIconName into tNewIconName
         if sAddFamily then
            put sFamily & "-" before tNewIconName
         end if
         put sIconData[sFamily][tIconName]["svg"] into \
               sIconData[pNewFamily][tNewIconName]["svg"]
         put sIconData[sFamily][tIconName]["codepoint"] into \
               sIconData[pNewFamily][tNewIconName]["codepoint"]
      end if
   end repeat
   iconFamilyChanged pNewFamily
end copyIconsToFamily

on closeCard
   setIconData sIconData
end closeCard

constant kHmargin = 6
constant kVmargin = 8
constant kSideMargin = 13
on resizeStack pNewWidth, pNewHeight, pOldWidth, pOldHeight
   local tWidth, tHeight, tTop, tBottom, tLeft, tObject
   revUpdateGeometry

   put the top of widget"icon 1" of group"row 1" into tTop
   put (pNewWidth -(kCols - 1) * kHmargin - 2 * kSideMargin) / kCols into tWidth
   put (((the top of widget"NavBar" of group id 1006 of me) - tTop - 4) - \
         (kRows - 1) * kVmargin) / kRows into tHeight
   repeat with tRow = 1 to kRows
      put kSideMargin into tLeft
      repeat with tCol = 1 to kCols
         put "widget" && quote & "icon " & tCol & quote && "of group" && \
               quote & "row " & tRow & quote into tObject
         set the rectangle of tObject to tLeft, tTop,(tLeft + tWidth),(tTop + tHeight)
         put tLeft + tWidth + kHmargin into tLeft
      end repeat
      put tTop + tHeight + kVmargin into tTop
   end repeat
end resizeStack