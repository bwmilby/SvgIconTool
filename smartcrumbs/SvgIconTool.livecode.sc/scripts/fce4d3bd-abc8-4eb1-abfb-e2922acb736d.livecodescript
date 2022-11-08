local sIconData


function extractPathFromSvg pSVG
   local tPath, tIndex, tLine
   --
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
   local tPath, tCreatePath
   --
   put prefsPath() into tPath
   if there is not a folder tPath then
      put true into tCreatePath
      if tPath is not revEnvironmentUserPluginsPath() & "/milby.us" then
         answer "Would you like to copy Svg Icon Tool to your plugin folder?" with "No" or "Yes"
         if it is "Yes" then
            put false into tCreatePath
            put URL ("binfile:" &(char 2 to - 2 of word 2 of the long name of this stack)) into \
                  URL ("binfile:" & revEnvironmentUserPluginsPath() & "/SvgIconTool.livecode")
            set the name of this stack to "SvgIconTool2"
            open stack revEnvironmentUserPluginsPath() & "/SvgIconTool.livecode"
            palette stack"SvgIconTool"
            close stack"SvgIconTool2"
         end if
      end if
      if tCreatePath then
         create folder tPath
      end if
   end if
   --
   loadPrefs
   if the hilite of button"ShowHelp" of card"settings" of me then
      go card"settings"
   else
      go card"grid"
   end if
end openStack


function getIconData
   return sIconData
end getIconData


on setIconData pIconData
   local tPath, tPrefs
   --
   put pIconData into sIconData
   put prefsPath() into tPath
   if sIconData is an array then
      put arrayEncode(sIconData) into URL ("binfile:" & tPath & "/SvgIconTool.icons")
   end if
end setIconData


on loadPrefs
   local tPath, tPrefs, tData
   put prefsPath() into tPath
   put URL ("binfile:" & tPath & "/SvgIconTool.icons") into tData
   if tData is not empty then
      try
         put arrayDecode(tData) into sIconData
      end try
   end if
   put URL ("binfile:" & tPath & "/SvgIconTool.prefs") into tData
   if tData is not empty then
      try
         put arrayDecode(tData) into tPrefs
         set the hilite of button"ShowHelp" of card"settings" of me to tPrefs["ShowHelp"]
         set the hilite of button"AddFamily" of card"settings" of me to tPrefs["AddFamily"]
      end try
   end if
end loadPrefs


on savePrefs
   local tPath, tPrefs
   put prefsPath() into tPath
   put the hilite of button"ShowHelp" of card"settings" of me into tPrefs["ShowHelp"]
   put the hilite of button"AddFamily" of card"settings" of me into tPrefs["AddFamily"]
   put arrayEncode(tPrefs) into URL ("binfile:" & tPath & "/SvgIconTool.prefs")
end savePrefs


function prefsPath
   set the itemDelimiter to "/"
   return (item 1 to - 2 of (char 2 to - 2 of word 2 of the long name of this stack)) & "/milby.us"
end prefsPath