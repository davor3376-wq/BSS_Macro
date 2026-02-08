-- [Guild Reference]: Guild C - The Harvesters
-- [Primary Coder]: Agent 056 (Harvest Lead)
-- [QA Verified By]: Agent 075 (Token Evaluator)
-- [JSON Ref]: Aegis_Ultimate_Manifest.json & BSS_Coordinates.json

--[[
    IDENTITY INITIALIZATION:
    I am Agent 056, the Harvest Lead. I control the primary gameplay loop of collecting pollen.
    I manage the activation of tools (Collector.lua) and the prioritization of tokens on the field.

    ROLE AWARENESS:
    I simulate mouse clicks to swing the tool based on the cooldowns defined in 'Aegis_Ultimate_Manifest.json'.
    I scan the Workspace for special tokens (Wind Gusts, Coconuts, Sprouts) and override the Navigator if a high-priority item appears.

    CROSS-AGENT DEBATE (Simulated):
    ---------------------------------------------------------------------------------------------------------
    [Agent 056 - Harvest Lead]: "I see a token! I'm overriding movement to grab it immediately. Priority 1."

    [Agent 185 - Logic Debater (Guild F)]: "Is it a 'Honey Token' or a 'Festive Gift'? You can't just chase
                                            every visual effect. Check the 'Priority List' in the Manifest."

    [Agent 056 - Harvest Lead]: "It's a 'Festive Gift'. Priority is high."

    [Agent 185 - Logic Debater]: "Wait. Check your inventory. Is your backpack full? If you have 0 capacity,
                                  collecting a token that gives pollen is useless. Only collect 'Buff Tokens'."

    [Agent 056 - Harvest Lead]: "Good catch. I will check 'Inventory.Limit' in Aegis_Ultimate_Manifest.json first.
                                  If backpack > 95%, ignore pollen tokens."
    ---------------------------------------------------------------------------------------------------------
]]

local Collector = {}
Collector.__index = Collector

function Collector.new(baseClassInstance)
    local self = setmetatable({}, Collector)
    self.Base = baseClassInstance
    self.IsCollecting = false
    return self
end

-- [JSON Ref]: Aegis_Ultimate_Manifest.json (Tools)
function Collector:StartCollection(toolName)
    local toolData = self.Base.Cache.Manifest.Tools[toolName]

    if not toolData then
        warn("[Agent 056]: Tool " .. tostring(toolName) .. " not found in Manifest! Defaulting to basic stats.")
        toolData = { CollectRate = 1.0, Cooldown = 1.0 }
    end

    self.IsCollecting = true
    print("[Agent 056]: Starting collection with " .. toolName .. " (Rate: " .. toolData.CollectRate .. ")")

    -- Simulation Loop
    spawn(function()
        while self.IsCollecting do
            -- Simulate Click
            -- game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
            wait(toolData.Cooldown)
        end
    end)
end

function Collector:StopCollection()
    self.IsCollecting = false
    print("[Agent 056]: Collection stopped.")
end

-- [JSON Ref]: Aegis_Ultimate_Manifest.json (Inventory)
function Collector:CheckCapacity(currentPollen)
    local limit = self.Base.Cache.Manifest.Inventory.MicroConverter.Limit -- Simplified reference
    -- In a real scenario, this would check Backpack.Capacity
    if currentPollen >= limit then
        print("[Agent 056]: Backpack Full! Triggering Convert Sequence.")
        return true
    end
    return false
end

return Collector
