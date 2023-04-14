# Dead Sea Scrolls Menu

A library that can be used to add a menu to your _[Binding of Isaac: Repentance](https://store.steampowered.com/app/1426300/The_Binding_of_Isaac_Repentance/)_ mod.

In order to use this mod:

1. merge the contents of the `resources` and `content` folders into your own mod's `resources` and `content` folders
2. copy the `dssmenucore.lua` file into a folder that your mod can `include` or `require`

`dssmenucore.lua` contains all of the basic functionality of the DSS menu, and is completely mod-independent, so you shouldn't need to change anything in it. It returns a Lua module like this:

```lua
return {
    ---The function to initialize the Dead Sea Scrolls library.
    ---@param DSSModName string A string used as an identifier for your mod's menu. It should be unique. We recommend something like "Dead Sea Scrolls (Mod Name)".
    ---@param MenuProvider DSSMenuProvider A table that MUST implement a certain set of functions. These are mostly data storage functions, as Dead Sea Scrolls does not natively handle data storage. This mod has a simple data storage implementation included that allows it to work on its own that you can reference.
    ---@return DSSMod
    DSSInitializerFunction = function(DSSModName, MenuProvider) end
}
```

`DSSMod` is a normal [`Mod`](https://wofsauge.github.io/IsaacDocs/rep/ModReference.html) object with some additional methods: `runMenu`, `openMenu`, and `closeMenu`.

Use `include` or `require` to get the initializer function for the menu, and then call it with the appropriate variables, and you're all set! You can reference the `main.lua` of this mod for an example of all of this used in action.

Because of how `dssmenucore.lua` is mod-independent, updating Dead Sea Scrolls to a newer version is as simple as copying its new contents over to your mod!

If you do need your own features for your menu, you can edit your mod's version of `dssmenucore.lua` without it affecting any other mod, as each mod runs its own instance of Dead Sea Scrolls for its own menu. Do note however that this will make it more difficult to update to a newer version!

A tutorial for adding a basic menu with a variety of configuration options can be found in `examplemod.lua`! Outside of that though, there is unfortunately not much documentation for the menu's features. Reference other mods that use it, like [Bertran](https://steamcommunity.com/sharedfiles/filedetails/?id=2297456697) and [Encyclopedia](https://steamcommunity.com/sharedfiles/filedetails/?id=2376005362). The mod selection menu implemented in `dssmenucore.lua` uses the same `AddMenu` syntax as any other mod menu, so you can compare to it as well.

Additional documentation made by [Slugcat](https://lookup.guru/334148476218769408) can be found at their [GitBook page](https://maya-bee.gitbook.io/dead-sea-scrolls/), and edited at their [GitHub repo](https://github.com/maya-bee/dss-docs), including visual tutorials and more in depth descriptions of DSS objects.
