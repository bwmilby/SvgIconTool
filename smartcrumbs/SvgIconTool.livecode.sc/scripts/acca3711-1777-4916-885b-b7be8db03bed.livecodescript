on menuPick pItemName
   dispatch "iconFamilyChanged" to card"grid" with pItemName
end menuPick

/*
These are functions for the buttons that use this as a behavior script
*/

local sMouseIsDown

on mouseDown pButtonNumber
   set the hilited of me to true
   put true into sMouseIsDown
   pass mouseDown
end mouseDown

on mouseUp pButtonNumber
   set the hilited of me to false
   if sMouseIsDown and the mouseloc is within the rect of me then
      pass mouseUp
   end if
   put false into sMouseIsDown
end mouseUp

on mouseDoubleUp pButtonNumber
   set the hilited of me to false
   put false into sMouseIsDown
end mouseDoubleUp

on mouseLeave
   set the hilited of me to false
   put false into sMouseIsDown
end mouseLeave