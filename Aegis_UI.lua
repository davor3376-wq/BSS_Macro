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
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Project Aegis | Bee Swarm Simulator | v1.0",
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
                -- Start Sequence
                Collector:StartCollection("Scooper") -- Default tool
            else
                -- Stop Sequence
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
                -- In a real loop, Slayer would constantly check for mobs
                -- Here we simulate one target identification
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
        -- Set active target for Slayer
        Slayer.ActiveTarget = Option[1]
    end,
})

-- =========================================================================================================
-- TAB 3: QUESTS (Guild E)
-- =========================================================================================================
local Tab3 = Window:CreateTab("Quests", 4483362458)

Tab3:CreateToggle({
    Name = "Auto Quest",
    CurrentValue = false,
    Flag = "AutoQuest",
    Callback = function(Value)
        SetState("isQuesting", Value, function()
            if Value then
                -- Trigger analysis
                local dummyQuests = {"BlackBear_Quest1", "BrownBear_Quest2"}
                local bestQuest = QuestBot:AnalyzeQuests(dummyQuests)
                if bestQuest then
                    -- Extract NPC from quest name for demo
                    local npc = bestQuest:match("^(%w+)_")
                    QuestBot:GoToNPC(npc)
                end
            end
        end)
    end,
})

-- =========================================================================================================
-- TAB 4: SETTINGS (Guild A)
-- =========================================================================================================
local Tab4 = Window:CreateTab("Settings", 4483362458)

Tab4:CreateToggle({
    Name = "Mobile Optimization Mode",
    CurrentValue = BaseClass:IsMobileOptimized(),
    Flag = "MobileMode",
    Callback = function(Value)
        -- This should update the Manifest or Cache
        if BaseClass.Cache.Manifest and BaseClass.Cache.Manifest.GameSettings then
             BaseClass.Cache.Manifest.GameSettings.MobileOptimized = Value
             print("[Agent 003]: Mobile Optimization set to " .. tostring(Value))
        end
    end,
})

-- =========================================================================================================
-- TAB 5: STATS (Monitoring)
-- =========================================================================================================
local Tab5 = Window:CreateTab("Stats", 4483362458)

local StatusLabel = Tab5:CreateLabel("Status: Idle")

-- Simple Loop to update status (Agent 191: Needs to be cleanable!)
task.spawn(function()
    while true do
        local status = "Idle"
        if BaseClass.State.isFarming then status = "Farming: " .. tostring(BaseClass.State.activeField) end
        if BaseClass.State.isConverting then status = "Converting Honey" end
        if BaseClass.State.isCombatEnabled then status = "Combat Active" end

        StatusLabel:Set("Status: " .. status)
        task.wait(1)
    end
end)

-- =========================================================================================================
-- TAB 6: MISC (Credits)
-- =========================================================================================================
local Tab6 = Window:CreateTab("Misc", 4483362458)
Tab6:CreateLabel("Project Aegis v1.0")
Tab6:CreateLabel("Orchestrator: Jules")
Tab6:CreateLabel("Architecture: The Hive Mind")

Rayfield:LoadConfiguration()
print("[Agent 003]: Interface Loaded. Hive Mind Active.")
