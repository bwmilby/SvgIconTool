Script "stack_SvgIconTool_card_id_1007"

/*
# Name: card "settings" of stack "SvgIconTool"
# ID: card id 1007 of stack "SvgIconTool"
*/


on preOpenCard
   set the hilitedItemName of widget "NavBar" to the short name of this card
   revUpdateGeometry
end preOpenCard
