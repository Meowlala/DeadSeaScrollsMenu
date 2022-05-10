# Dead Sea Scrolls Menu
A mod library that can be used to add a menu to your Isaac mod.

In order to use this mod, first merge the contents of the `resources` and `content` folders into your own mod's `resources` and `content` folders, and copy the `main.lua` of this mod into another lua file that your mod can require (usually, it's named something like `modnamemenu.lua`).

At the beginning of this mod's `main.lua` are two variables, `DSSModName`, and `DSSCoreVersion`. `DSSModName` should be a name unique to your mod, which will be used as a menu identifier. The usual naming scheme is "Dead Sea Scrolls Menu (Mod Name)". `DSSCoreVersion` must be included, but should usually just be left as it is in this mod's `main.lua`. The mod with the highest `DSSCoreVersion` is the mod that runs the "main mod menu", which allows you to select and enter other mod menus, so if you use a higher version, make absolutely sure that it works to select other mod menus and important cross mod options.

At the end of this mod's `main.lua` is a comment `--  OVERRIDE ALL MenuProvider FUNCTIONS WITH YOUR OWN MOD'S, DEAD SEA SCROLLS MENU WILL HANDLE THE REST`. All `MenuProvider` functions past that point MUST be reimplemented by your mod for it to work properly, these are mostly data storage functions as Dead Sea Scrolls does not natively handle data storage. This mod has a simple data storage implementation included that allows it to work on its own that you can reference.

There is unfortunately not yet any documentation for the menu's features. Reference other mods that use it, like [Bertran](https://steamcommunity.com/sharedfiles/filedetails/?id=2297456697) and [Encyclopedia](https://steamcommunity.com/sharedfiles/filedetails/?id=2376005362). The mod selection menu is also implemented in the same way as mod menus are in this `main.lua`, so you can compare to that.
