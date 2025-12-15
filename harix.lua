-- FAST SELECT | FLUENT FULL VERSION

-- LOAD FLUENT
local Fluent = loadstring(game:HttpGet(
    "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
))()

local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"
))()

local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"
))()

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- STATES
local character, humanoid
local selectedTools = {}

local multiEquip = false
local autoUse = false
local equipSpeed = 0.05

local equipConn, autoUseConn

--------------------------------------------------
-- WINDOW
--------------------------------------------------

local Window = Fluent:CreateWindow({
    Title = "Fast Select | HERIX",
    SubTitle = "Multi Equip & Auto Use",
    TabWidth = 110,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Rose",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "box" }),
    Tools = Window:AddTab({ Title = "Tools", Icon = "wrench" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

--------------------------------------------------
-- FUNCTIONS
--------------------------------------------------

local function updateCharacter(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end

local function startMultiEquip()
    if equipConn then equipConn:Disconnect() end
    equipConn = RunService.Heartbeat:Connect(function()
        if not multiEquip or not humanoid then return end

        for _, tool in ipairs(selectedTools) do
            if tool and tool.Parent ~= character then
                tool.Parent = character
                task.wait(equipSpeed)
                humanoid:EquipTool(tool)
            end
        end
    end)
end

local function startAutoUse()
    if autoUseConn then autoUseConn:Disconnect() end
    autoUseConn = RunService.Heartbeat:Connect(function()
        if not autoUse or not character then return end

        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function()
                tool:Activate()
            end)
        end
    end)
end

--------------------------------------------------
-- MAIN TAB
--------------------------------------------------

Tabs.Main:AddToggle("MultiEquip", {
    Title = "Multi Equip",
    Default = false
}):OnChanged(function()
    multiEquip = Options.MultiEquip.Value
    if multiEquip then
        startMultiEquip()
    elseif equipConn then
        equipConn:Disconnect()
    end
end)

Tabs.Main:AddToggle("AutoUse", {
    Title = "Auto Use",
    Default = false
}):OnChanged(function()
    autoUse = Options.AutoUse.Value
    if autoUse then
        startAutoUse()
    elseif autoUseConn then
        autoUseConn:Disconnect()
    end
end)

Tabs.Main:AddSlider("Speed", {
    Title = "Equip Speed",
    Description = "Max 1000 (high values may lag)",
    Default = 500,
    Min = 1,
    Max = 1000,
    Rounding = 0
}):OnChanged(function(Value)
    equipSpeed = 0.5 / (Value / 100)
end)

--------------------------------------------------
-- TOOLS TAB
--------------------------------------------------

Tabs.Tools:AddButton({
    Title = "Add Held Tool",
    Description = "Adds the tool you are holding",
    Callback = function()
        if not character then return end

        local tool = character:FindFirstChildOfClass("Tool")
        if tool and not table.find(selectedTools, tool) then
            table.insert(selectedTools, tool)
            Fluent:Notify({
                Title = "Tool Added",
                Content = tool.Name,
                Duration = 2
            })
        end
    end
})

Tabs.Tools:AddButton({
    Title = "Remove Held Tool",
    Description = "Removes held tool from list",
    Callback = function()
        if not character then return end

        local tool = character:FindFirstChildOfClass("Tool")
        if not tool then return end

        for i, t in ipairs(selectedTools) do
            if t == tool then
                table.remove(selectedTools, i)
                Fluent:Notify({
                    Title = "Tool Removed",
                    Content = tool.Name,
                    Duration = 2
                })
                break
            end
        end
    end
})

Tabs.Tools:AddButton({
    Title = "Clear Tool List",
    Callback = function()
        table.clear(selectedTools)
        Fluent:Notify({
            Title = "Cleared",
            Content = "All tools removed",
            Duration = 2
        })
    end
})

--------------------------------------------------
-- CHARACTER
--------------------------------------------------

player.CharacterAdded:Connect(updateCharacter)
if player.Character then
    updateCharacter(player.Character)
end

--------------------------------------------------
-- MANAGERS
--------------------------------------------------

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FastSelect")
SaveManager:SetFolder("FastSelect/Configs")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

--------------------------------------------------
-- FINAL
--------------------------------------------------

Window:SelectTab(1)

Fluent:Notify({
    Title = "HERIX Loaded",
    Content = "V.1.9 by script forge",
    Duration = 10
})

SaveManager:LoadAutoloadConfig()


--================== Credits Tab ==================--
local CreditsTab = Window:AddTab({ Title = "Credits", Icon = "info" })

CreditsTab:AddParagraph({
    Title = "HERIX HUB",
    Content = "FAST SELECTER."
})

CreditsTab:AddParagraph({
    Title = "Creator",
    Content = "Script Forge\n\nMain Developer "
})

CreditsTab:AddParagraph({
    Title = "SUPORTER",
    Content = "MARIANO_D3\n\nSUPORTER Developer "
})


CreditsTab:AddParagraph({
    Title = "Special Thanks",
    Content = " Testers & Supporters"
})

CreditsTab:AddButton({
    Title = "YouTube - Script Forge",
    Description = "Visit the official YouTube channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@SCRIPTFORGE.O")
        Fluent:Notify({
            Title = "Copied!",
            Content = "YouTube link copied to clipboard",
            Duration = 2
        })
    end
})


CreditsTab:AddParagraph({
    Title = "Version",
    Content = "HERIX Hub v1.9\nPowaered by SCRIPT FORGE "
})
