--
-- Generic and very straightforward data storage system used in the MenuProvider functions below
-- Use your own mod's functions for this if it has them! If not, however, feel free to copy this and change the mod name.
--
local myMod = RegisterMod("Example Mod!", 1)
myMod.menusavedata = nil

local json = require("json")
function myMod.GetSaveData()
    if not myMod.menusavedata then
        if Isaac.HasModData(myMod) then
            myMod.menusavedata = json.decode(Isaac.LoadModData(myMod))
        else
            myMod.menusavedata = {}
        end
    end

    return myMod.menusavedata
end

function myMod.StoreSaveData()
    Isaac.SaveModData(myMod, json.encode(myMod.menusavedata))
end

--
-- End of generic data storage manager
--

--
-- MenuProvider
--

-- Change this variable to match your mod. The standard is "Dead Sea Scrolls (Mod Name)"
local DSSModName = "Dead Sea Scrolls (My Example Mod!)"

-- Every MenuProvider function below must have its own implementation in your mod, in order to handle menu save data.
local MenuProvider = {}

function MenuProvider.SaveSaveData()
    myMod.StoreSaveData()
end

function MenuProvider.GetPaletteSetting()
    return myMod.GetSaveData().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    myMod.GetSaveData().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return myMod.GetSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        myMod.GetSaveData().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return myMod.GetSaveData().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    myMod.GetSaveData().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return myMod.GetSaveData().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    myMod.GetSaveData().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return myMod.GetSaveData().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    myMod.GetSaveData().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return myMod.GetSaveData().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    myMod.GetSaveData().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return myMod.GetSaveData().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    myMod.GetSaveData().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return myMod.GetSaveData().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    myMod.GetSaveData().MenusPoppedUp = var
end

local dssmenucore = include("dssmenucore")

-- This function returns a table that some useful functions and defaults are stored on
local dssmod = dssmenucore:DSSInitializerFunction(DSSModName, MenuProvider)


-- Adding a Menu


-- Creating a menu like any other DSS menu is a simple process.
-- You need a "Directory", which defines all of the pages ("items") that can be accessed on your menu, and a "DirectoryKey", which defines the state of the menu.
local exampledirectory = {
    -- The keys in this table are used to determine button destinations.
    main = {
        -- "title" is the big line of text that shows up at the top of the page!
        title = 'example mod!',

        -- "buttons" is a list of objects that will be displayed on this page. The meat of the menu!
        buttons = {
            -- The simplest button has just a "str" tag, which just displays a line of text.
            
            -- The "action" tag can do one of three pre-defined actions:
            --- "resume" closes the menu, like the resume game button on the pause menu. Generally a good idea to have a button for this on your main page!
            --- "back" backs out to the previous menu item, as if you had sent the menu back input
            --- "openmenu" opens a different dss menu, using the "menu" tag of the button as the name
            {str = 'resume game', action = 'resume'},

            -- The "dest" option, if specified, means that pressing the button will send you to that page of your menu.
            -- If using the "openmenu" action, "dest" will pick which item of that menu you are sent to.
            {str = 'settings', dest = 'settings'},

            -- A few default buttons are provided in the table returned from DSSInitializerFunction.
            -- They're buttons that handle generic menu features, like changelogs, palette, and the menu opening keybind
            -- They'll only be visible in your menu if your menu is the only mod menu active; otherwise, they'll show up in the outermost Dead Sea Scrolls menu that lets you pick which mod menu to open.
            -- This one leads to the changelogs menu, which contains changelogs defined by all mods.
            dssmod.changelogsButton,

            -- Text font size can be modified with the "fsize" tag. There are three font sizes, 1, 2, and 3, with 1 being the smallest and 3 being the largest.
            {str = 'look at the little text!', fsize = 1}
        },

        -- A tooltip can be set either on an item or a button, and will display in the corner of the menu while a button is selected or the item is visible with no tooltip selected from a button.
        -- The object returned from DSSInitializerFunction contains a default tooltip that describes how to open the menu, at "menuOpenToolTip"
        -- It's generally a good idea to use that one as a default!
        tooltip = dssmod.menuOpenToolTip
    },
    settings = {
        title = 'settings',
        buttons = {
            -- These buttons are all generic menu handling buttons, provided in the table returned from DSSInitializerFunction
            -- They'll only show up if your menu is the only mod menu active
            -- You should generally include them somewhere in your menu, so that players can change the palette or menu keybind even if your mod is the only menu mod active.
            -- You can position them however you like, though!
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,
            dssmod.menuHintButton,
            dssmod.menuBuzzerButton,

            {
                str = 'choice option',

                -- The "choices" tag on a button allows you to create a multiple-choice setting
                choices = {'choice a', 'choice b', 'choice c'},
                -- The "setting" tag determines the default setting, by list index. EG "1" here will result in the default setting being "choice a"
                setting = 1,

                -- "variable" is used as a key to story your setting; just set it to something unique for each setting!
                variable = 'ExampleChoiceOption',
                
                -- When the menu is opened, "load" will be called on all settings-buttons
                -- The "load" function for a button should return what its current setting should be
                -- This generally means looking at your mod's save data, and returning whatever setting you have stored
                load = function()
                    return myMod.GetSaveData().exampleoption or 1
                end,

                -- When the menu is closed, "store" will be called on all settings-buttons
                -- The "store" function for a button should save the button's setting (passed in as the first argument) to save data!
                store = function(var)
                    myMod.GetSaveData().exampleoption = var
                end,

                -- A simple way to define tooltips is using the "strset" tag, where each string in the table is another line of the tooltip
                tooltip = {strset = {'configure', 'my options', 'please!'}}
            },
            {
                str = 'slider option',

                -- The "slider" tag allows you to make a button a slider, with notches that are transparent / opaque depending on if they're filled.
                slider = true,
                -- Increment determines how much the value of the slider changes with each notch
                increment = 1,
                -- Max determines the maximum value of the slider. The number of notches is equal to max / increment!
                max = 10,
                -- Setting determines the initial value of the slider
                setting = 1,

                -- "variable" is used as a key to story your setting; just set it to something unique for each setting!
                variable = 'ExampleSliderOption',
                
                -- These functions work just like in the choice option!
                load = function()
                    return myMod.GetSaveData().exampleslider or 1
                end,
                store = function(var)
                    myMod.GetSaveData().exampleslider = var
                end,

                tooltip = {strset = {'like a slide!'}}
            },
            {
                str = 'number option',

                -- If "min" and "max" are set without "slider", you've got yourself a number option!
                -- It will allow you to scroll through the entire range of numbers from "min" to "max", incrementing by "increment"
                min = 20,
                max = 100,
                increment = 5,

                -- You can also specify a prefix or suffix that will be applied to the number, which is especially useful for percentages!
                pref = 'hi! ',
                suf = '%',

                setting = 20,

                variable = "ExampleNumberOption",

                load = function()
                    return myMod.GetSaveData().examplenumber or 20
                end,
                store = function(var)
                    myMod.GetSaveData().examplenumber = var
                end,

                tooltip = {strset = {"who knows", "what it could", "mean"}},
            },
            {
                str = 'keybind option',

                -- A keybind option lets you bind a key!
                keybind = true,
                -- -1 means no key set, otherwise use the Keyboard enum!
                setting = -1,

                variable = "ExampleKeybindOption",

                load = function()
                    return myMod.GetSaveData().examplekeybind or -1
                end,
                store = function(var)
                    myMod.GetSaveData().examplekeybind = var
                end,

                tooltip = {strset = {"it's the key!"}},
            },
            {
                -- Creating gaps in your page can be done simply by inserting a blank button.
                -- The "nosel" tag will make it impossible to select, so it'll be skipped over when traversing the menu, while still rendering!
                str = '',
                fsize = 2,
                nosel = true
            },
            {
                str = 'kill me!',

                -- If you want a button to do something unusual, you can have it call a function using the "func" tag!
                -- The function passes in "button", which is this button object, "item", which is the item object containing these buttons, and "menuObj", which is what you pass into AddMenu (contains DirectoryKey and Directory!)
                func = function(button, item, menuObj)
                    Isaac.GetPlayer():Kill()
                end,

                -- "displayif" allows you to dynamically hide or show a button. If you return true, it will display, and if you return false, it won't!
                -- It passes in all the same args as "func"
                -- In this example, this button will be hidden if the "slider option" button above is set to its maximum value.
                displayif = function(button, item, menuObj)
                    if item and item.buttons then
                        for _, btn in ipairs(item.buttons) do
                            if btn.str == 'slider option' and btn.setting == 10 then
                                return false
                            end
                        end
                    end

                    return true
                end,

                -- The "generate" function is run the very first time a button displays upon switching to its item
                -- You can use this to change the button's data dynamically, for instance for a menu that uses non-constant data.
                -- In this example, it's just a random chance to change the string the button displays, but you could do pretty much anything!
                generate = function(button, item, tbl)
                    if math.random(1, 100) == 1 then
                        button.str = "really kill me!"
                    else
                        button.str = "kill me!"
                    end
                end,

                tooltip = {strset = {'press this', 'to kill', 'isaac!'}}
            },
        }
    }
}

local exampledirectorykey = {
    Item = exampledirectory.main, -- This is the initial item of the menu, generally you want to set it to your main item
    Main = 'main', -- The main item of the menu is the item that gets opened first when opening your mod's menu.

    -- These are default state variables for the menu; they're important to have in here, but you don't need to change them at all.
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Example Mod Menu!", {
    -- The Run, Close, and Open functions define the core loop of your menu
    -- Once your menu is opened, all the work is shifted off to your mod running these functions, so each mod can have its own independently functioning menu.
    -- The DSSInitializerFunction returns a table with defaults defined for each function, as "runMenu", "openMenu", and "closeMenu"
    -- Using these defaults will get you the same menu you see in Bertran and most other mods that use DSS
    -- But, if you did want a completely custom menu, this would be the way to do it!
    
    -- This function runs every render frame while your menu is open, it handles everything! Drawing, inputs, etc.
    Run = dssmod.runMenu,
    -- This function runs when the menu is opened, and generally initializes the menu.
    Open = dssmod.openMenu,
    -- This function runs when the menu is closed, and generally handles storing of save data / general shut down.
    Close = dssmod.closeMenu,

    -- If UseSubMenu is set to true, when other mods with UseSubMenu set to false / nil are enabled, your menu will be hidden behind an "Other Mods" button.
    -- A good idea to use to help keep menus clean if you don't expect players to use your menu very often!
    UseSubMenu = false,

    Directory = exampledirectory,
    DirectoryKey = exampledirectorykey
})

-- There are a lot more features that DSS supports not covered here, like sprite insertion and scroller menus, that you'll have to look at other mods for reference to use.
-- But, this should be everything you need to create a simple menu for configuration or other simple use cases!
