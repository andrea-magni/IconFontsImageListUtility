# IconFontsImageListUtility
Utility companion for [IconFontsImageList](https://github.com/EtheaDev/IconFontsImageList) project

This utility can generate constant definitions to represent icons in icon fonts.
At the moment two fonts are supported:
 - [MaterialDesignIcons](http://materialdesignicons.com/)
 - [FontAwesome](https://fontawesome.com/)

Dependencies:
  - [MARS-Curiosity REST library](https://github.com/andrea-magni/MARS)
  
If you are looking for icon defitions, just look into the [Generated folder](https://github.com/andrea-magni/IconFontsImageListUtility/tree/master/Generated).
Usage:
 - Include unit (i.e. Icons.MaterialDesign)
 - single access: MD.account_search: TIconEntry
   - MD.account_search.name: original name of the icon
   - MD.account_search.codepoint: codepoint of the icon
 - batch access: MD.\_entries: array [0..5347] of TIconEntry
   
