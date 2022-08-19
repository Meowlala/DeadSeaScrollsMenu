--
-- Generic and very straightforward data storage system used in the MenuProvider functions below
-- Use your own mod's functions for this if it has them! If not, however, feel free to copy this and change the mod name.
--
local saveDataMod = RegisterMod("Dead Sea Scrolls Workshop", 1)
saveDataMod.menusavedata = nil

local json = require("json")
function saveDataMod.GetSaveData()
    if not saveDataMod.menusavedata then
        if Isaac.HasModData(saveDataMod) then
            saveDataMod.menusavedata = json.decode(Isaac.LoadModData(saveDataMod))
        else
            saveDataMod.menusavedata = {}
        end
    end

    return saveDataMod.menusavedata
end

function saveDataMod.StoreSaveData()
    Isaac.SaveModData(saveDataMod, json.encode(saveDataMod.menusavedata))
end

--
-- End of generic data storage manager
--

--
-- Start of menu code
--

-- Change this variable to match your mod. The standard is "Dead Sea Scrolls (Mod Name)"
local DSSModName = "Dead Sea Scrolls (Main)"

-- DSSCoreVersion determines which menu controls the mod selection menu that allows you to enter other mod menus.
-- Don't change it unless you really need to and make sure if you do that you can handle mod selection and global mod options properly.
local DSSCoreVersion = 5

-- Every MenuProvider function below must have its own implementation in your mod, in order to handle menu save data.
local MenuProvider = {}

function MenuProvider.SaveSaveData()
    saveDataMod.StoreSaveData()
end

function MenuProvider.GetPaletteSetting()
    return saveDataMod.GetSaveData().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    saveDataMod.GetSaveData().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return saveDataMod.GetSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        saveDataMod.GetSaveData().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return saveDataMod.GetSaveData().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    saveDataMod.GetSaveData().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return saveDataMod.GetSaveData().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    saveDataMod.GetSaveData().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return saveDataMod.GetSaveData().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    saveDataMod.GetSaveData().MenuHint = var
end

function MenuProvider.GetMenusNotified()
    return saveDataMod.GetSaveData().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    saveDataMod.GetSaveData().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return saveDataMod.GetSaveData().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    saveDataMod.GetSaveData().MenusPoppedUp = var
end

local DSSInitializerFunction = include("dssmenucore")
DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)
