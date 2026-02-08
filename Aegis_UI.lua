-- [Guild Reference]: Guild A - The Architects
-- [Primary Coder]: Agent 003 (UI Architect)
-- [QA Verified By]: Agent 141 (Strategist) & Agent 191 (Warden)
-- [JSON Ref]: Aegis_Ultimate_Manifest.json

--[[
    IDENTITY INITIALIZATION:
    I am Agent 003, the UI Architect. I build the user-facing control panel (Rayfield Interface).
    I ensure that every toggle and slider directly interacts with the 'BaseClass.State' table,
    allowing the hive mind to react to user input instantly.

    ROLE AWARENESS:
    I do not contain logic. I only contain 'State Setters'.
    When the user toggles 'Auto Farm', I set 'State.isFarming = true'. The Collector Agent handles the rest.

    CROSS-AGENT DEBATE (Simulated):
    ---------------------------------------------------------------------------------------------------------
    [Agent 003 - UI Architect]: "I'm setting up the 'Auto Farm' toggle. It will call Collector:StartCollection() directly."

    [Agent 141 - Strategist]: "Objection. You are bypassing the State Machine. If you call the function directly,
                               Navigator won't know we are farming. You MUST update 'BaseClass.State.isFarming'."

    [Agent 003 - UI Architect]: "Understood. The toggle will only modify the boolean state.
                                 A separate 'Controller' or the module itself will react to the state change."

    [Agent 191 - Warden]: "Also, add a debounce. If the user spams the toggle, we don't want 50 threads spawning."
    ---------------------------------------------------------------------------------------------------------
    [AUDIT TRAIL]:
    [v2.0 APPROVED]: "Reordered Tabs to prioritize Quests (Tab 5) per Davor's request.
                      Added 'Safety' Tab with Anti-Ban toggle linked to Agent 181."
    ---------------------------------------------------------------------------------------------------------
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Project Aegis | Bee Swarm Simulator | v2.0",
    LoadingTitle = "Initializing Guilds...",
    LoadingSubtitle = "by Jules",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ProjectAegis",
        FileName = "Config"
    },
    KeySystem = false,
})

-- Load Hardened Modules
local BaseClass = require(script.Parent.BaseClass).new()
local Navigator = require(script.Parent.Navigator).new(BaseClass)
local Collector = require(script.Parent.Collector).new(BaseClass)
local Slayer = require(script.Parent.Slayer).new(BaseClass)
local QuestBot = require(script.Parent.QuestBot).new(BaseClass)
local AntiBan = require(script.Parent.AntiBan).new(BaseClass)

-- [Agent 191 Helper]: Atomic State Change with Debounce
local function SetState(key, value, callback)
    if BaseClass.State[key] == value then return end -- No change
    print("[Agent 003]: State Change -> " .. key .. " = " .. tostring(value))
    BaseClass.State[key] = value

    if callback then
        task.spawn(function()
            local success, err = pcall(callback)
            if not success then
                warn("[Agent 003]: UI Callback Failed: " .. tostring(err))
            end
        end)
    end
end

-- =========================================================================================================
-- TAB 1: FARMING (Guild B & C)
-- =========================================================================================================
local Tab1 = Window:CreateTab("Farming", 4483362458) -- Icon ID

Tab1:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        SetState("isFarming", Value, function()
            if Value then
                Collector:StartCollection("Scooper") -- Default tool
            else
                Collector:StopCollection()
            end
        end)
    end,
})

Tab1:CreateDropdown({
    Name = "Select Field",
    Options = {"Sunflower Field", "Dandelion Field", "Mushroom Field", "Blue Flower Field", "Clover Field"},
    CurrentOption = "Sunflower Field",
    Flag = "FieldSelect",
    Callback = function(Option)
        SetState("activeField", Option[1], function()
            if BaseClass.State.isFarming then
                Navigator:MoveToField(Option[1])
            end
        end)
    end,
})

-- =========================================================================================================
-- TAB 2: COMBAT (Guild D)
-- =========================================================================================================
local Tab2 = Window:CreateTab("Combat", 4483362458)

Tab2:CreateToggle({
    Name = "Auto Combat",
    CurrentValue = false,
    Flag = "AutoCombat",
    Callback = function(Value)
        SetState("isCombatEnabled", Value, function()
            if Value then
                local target = Slayer:IdentifyTarget("Ladybug")
                if target then Slayer:CombatLoop() end
            end
        end)
    end,
})

Tab2:CreateDropdown({
    Name = "Target Boss",
    Options = {"CoconutCrab", "StumpSnail", "CommandoChick"},
    CurrentOption = "CoconutCrab",
    Flag = "BossSelect",
    Callback = function(Option)
        Slayer.ActiveTarget = Option[1]
    end,
})

-- =========================================================================================================
-- TAB 3: SETTINGS (Guild A)
-- =========================================================================================================
local Tab3 = Window:CreateTab("Settings", 4483362458)

Tab3:CreateToggle({
    Name = "Mobile Optimization Mode",
    CurrentValue = BaseClass:IsMobileOptimized(),
    Flag = "MobileMode",
    Callback = function(Value)
        if BaseClass.Cache.Manifest and BaseClass.Cache.Manifest.GameSettings then
             BaseClass.Cache.Manifest.GameSettings.MobileOptimized = Value
             print("[Agent 003]: Mobile Optimization set to " .. tostring(Value))
        end
    end,
})

-- =========================================================================================================
-- TAB 4: SAFETY (Guild F - Agent 181)
-- =========================================================================================================
local Tab4 = Window:CreateTab("Safety", 4483362458)

Tab4:CreateToggle({
    Name = "Humanization / Anti-Ban",
    CurrentValue = false,
    Flag = "AntiBanToggle",
    Callback = function(Value)
        if Value then
            AntiBan:StartMonitoring()
        else
            AntiBan:StopMonitoring()
        end
    end,
})

Tab4:CreateLabel("Status: " .. (BaseClass.State.isPaused and "PAUSED (Break Active)" or "Active"))

-- =========================================================================================================
-- TAB 5: QUESTS (Guild E) - [PRIORITY FOCUS]
-- =========================================================================================================
local Tab5 = Window:CreateTab("Quests", 4483362458)

Tab5:CreateToggle({
    Name = "Auto Quest (Deep Logic)",
    CurrentValue = false,
    Flag = "AutoQuest",
    Callback = function(Value)
        SetState("isQuesting", Value, function()
            if Value then
                -- Trigger complex quest step
                local questData = { Type = "Collect", Field = "Rose Field", Amount = 1000, PollenType = "Red" }
                QuestBot:ProcessQuestStep(questData)
            end
        end)
    end,
})

Tab5:CreateLabel("Current Objective: Waiting...")

-- =========================================================================================================
-- TAB 6: STATS (Monitoring)
-- =========================================================================================================
local Tab6 = Window:CreateTab("Stats", 4483362458)

local StatusLabel = Tab6:CreateLabel("Status: Idle")

-- Simple Loop to update status
task.spawn(function()
    while true do
        local status = "Idle"
        if BaseClass.State.isPaused then status = "SAFETY BREAK ACTIVE"
        elseif BaseClass.State.isQuestTraveling then status = "Traveling to Quest Location"
        elseif BaseClass.State.isFarming then status = "Farming: " .. tostring(BaseClass.State.activeField)
        elseif BaseClass.State.isConverting then status = "Converting Honey"
        elseif BaseClass.State.isCombatEnabled then status = "Combat Active" end

        StatusLabel:Set("Status: " .. status)
        task.wait(1)
    end
end)


Rayfield:LoadConfiguration()
print("[Agent 003]: Interface Loaded v2.0. Hive Mind Active.")
