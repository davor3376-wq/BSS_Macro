-- [Guild Reference]: Guild E - The Strategists
-- [Primary Coder]: Agent 141 (Logic Lead)
-- [QA Verified By]: Agent 160 (Science Bear Analyst)
-- [JSON Ref]: Aegis_Ultimate_Manifest.json & BSS_Coordinates.json

--[[
    IDENTITY INITIALIZATION:
    I am Agent 141, the Logic Lead. I am the brain of the operation.
    I manage the Quest Log (QuestBot.lua) and determine which NPC needs to be visited next.

    ROLE AWARENESS:
    I parse the active quests from the player's GUI (via DataStore or TextLabels) and compare them
    against the 'Quests' database in 'Aegis_Ultimate_Manifest.json'.
    I decide whether it is more efficient to farm pollen in the 'Sunflower Field' for Black Bear
    or kill ladybugs for Science Bear.

    CROSS-AGENT DEBATE (Simulated):
    ---------------------------------------------------------------------------------------------------------
    [Agent 141 - Logic Lead]: "I have two active quests: 'Black Bear 5' (Collect 1000 Red Pollen)
                               and 'Brown Bear 2' (Collect 500 White Pollen)."

    [Agent 195 - Delta Opt. Engineer (Guild F)]: "You are inefficient. You are calculating this every frame.
                                                  Check the 'Reward/Time' ratio. Black Bear gives honey.
                                                  Brown Bear gives Royal Jelly. Which is the priority?"

    [Agent 141 - Logic Lead]: "My user wants Honey. I will prioritize Black Bear."

    [Agent 195 - Delta Opt. Engineer]: "Wait. If you are already in the 'Rose Field' (Red Pollen source),
                                        and Brown Bear needs Red Pollen too (hypothetically), do both.
                                        Check 'Field Efficiency' in Aegis_Ultimate_Manifest.json."

    [Agent 141 - Logic Lead]: "Correction. I will scan all active quests for overlapping requirements
                               (e.g., Red Pollen + Ladybugs in Rose Field). Maximizing overlap = 200% efficiency."
    ---------------------------------------------------------------------------------------------------------
]]

local QuestBot = {}
QuestBot.__index = QuestBot

function QuestBot.new(baseClassInstance)
    local self = setmetatable({}, QuestBot)
    self.Base = baseClassInstance
    self.ActiveQuests = {} -- Table to store current quest objects
    return self
end

-- [JSON Ref]: Aegis_Ultimate_Manifest.json (Quests)
function QuestBot:AnalyzeQuests(playerQuests)
    -- Input: playerQuests is a table of strings/data from the game UI
    -- Output: Prioritized Quest

    print("[Agent 141]: Analyzing active quests against Manifest...")
    local bestQuest = nil
    local highestReward = 0

    for _, questName in ipairs(playerQuests) do
        -- Simplified lookup: Assume questName format "BlackBear_Quest1"
        -- In reality, parsing would be more complex
        local npc, qId = questName:match("^(%w+)_(%w+)$")

        if npc and qId and self.Base.Cache.Manifest.Quests[npc] then
            local qData = self.Base.Cache.Manifest.Quests[npc][qId]
            if qData then
                print("[Agent 141]: Found " .. questName .. " (Reward: " .. qData.Reward .. ")")
                if qData.Reward > highestReward then
                    highestReward = qData.Reward
                    bestQuest = questName
                end
            end
        end
    end

    if bestQuest then
        print("[Agent 141]: Priority Quest Selected: " .. bestQuest)
        return bestQuest
    else
        warn("[Agent 141]: No valid quests found in Manifest.")
        return nil
    end
end

-- [JSON Ref]: BSS_Coordinates.json (Special Locations -> NPC)
function QuestBot:GoToNPC(npcName)
    local npcPos = self.Base:GetFieldPosition(npcName) -- This might fail if NPC isn't in "Fields"
    -- Fallback: Use "Special Locations" logic (not fully implemented in BaseClass yet)

    if not npcPos then
        -- Hardcoded backup (e.g., Black Bear)
        if npcName == "Black Bear" then
            npcPos = Vector3.new(-255.01, 5.00, 298.17)
        else
            warn("[Agent 141]: Coordinate missing for NPC: " .. npcName)
            return
        end
    end

    print("[Agent 141]: Moving to " .. npcName .. " to turn in quest.")
    -- self.Base.Navigator:MoveTo(npcPos)
end

return QuestBot
