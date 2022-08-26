# SVG Icon Tool

## LiveCode tool to manage SVG Icon Families

### Install

To install the plugin, copy the **SvgIconTool.livecode** file to your plugins
folder.  If previously launched, the **milby.us** folder may also be copied
to retain any icons that were imported.  On the first launch (detected by there
not being a saved preference file), a prompt will ask if the stack should be
copied to the plugins folder.  To install all of the icon families, drag the icons folder to the Library card.

### Icon Card

Drag a SVG file to the **Icon** card to see the file and path.  Click the open
folder icon or double click the file name field to select a file.

### Family Card

Drag a folder of SVG files to the **Family** card to get a list.  You can arrow
up/down though the list to view icons individually.  Click the open folder icon
or double click the family path field to select a folder.

### Grid Card

The **Grid** card displays 80 icons per page.  Use left/right arrow keys to
navigate to previous/next pages of icons.  Use up/down arrow keys to change
families of imported icons.

Click on icons to select them.  Selected icons can be copied and pasted into
another stack (only visible icons are copied).  Double-click an icon to copy the
icon widget to the clipboard.

An individual family can be saved or deleted from this card using the
appropriate buttons.  The filled star selects all icons in the family (including
those not visible).  The hollow star de-selects all icons.  The duplicate icon
will create a new (or add to an existing) family containing the selected icons.

### Library Card

The **Library** card allow for icon families to be loaded into the SVG Icon
Library (requires 9.0rc1 or later).  It also allows the setting of the current
icon family which is used in other widgets for choosing icons.

Multiple family export files can be dragged onto the card to import them into
the tool.

### Settings Card

If you used the icon picker to select an icon and then change to a different
family, you may not see what you expect.  The icons are displayed from the
current family and if not there then the other families are searched (no
guarantee on order).  The first name match is the one used.  This is why there
is an option to prepend the family when copying icons since it will avoid this
issue.

### Older Versions

https://milby.us/lc/SvgIconTool.zip is a copy of the 3/19/2018 version with many
icons from https://github.com/leungwensen/svg-icon included.  All of the
families included there are available in this repository in the **Icons**
folder.