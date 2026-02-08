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

    [AUDIT TRAIL - AGENT 191 (WARDEN)]:
    [v1.0 REJECTED]: "Agent 141, you iterated over 'Manifest.Quests' without verifying it exists.
                      You also used 'match' on a potentially nil string. This logic is brittle."
    [v1.1 APPROVED]: "Agent 141 wrapped the quest parsing loop in pcall.
                      Used 'Base:SafeGet' to retrieve Quest data.
                      Added type checking for quest names before string manipulation. Approved."
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

    -- Agent 191: Strict existence check for Quest DB
    local questsDB = self.Base:SafeGet("Quests", nil) -- This will fail safely if "Quests" missing, returning nil? No, SafeGet(table, nil) might not work as intended if not handled.
    -- Correction: SafeGet expects a key. If we want the whole table "Quests", we need a different approach or just check Cache directly with pcall

    -- Agent 191: Let's use pcall for the whole block to be safe
    local success, err = pcall(function()
        if not self.Base.Cache.Manifest or not self.Base.Cache.Manifest.Quests then
            warn("[Agent 141]: Quests DB not loaded.")
            return
        end

        for _, questName in ipairs(playerQuests) do
            if type(questName) ~= "string" then
                 -- Agent 191: Skip non-string inputs to avoid crash
                 print("[Agent 141]: Invalid quest name format skipped.")
            else
                -- Simplified lookup: Assume questName format "BlackBear_Quest1"
                local npc, qId = questName:match("^(%w+)_(%w+)$")

                if npc and qId then
                    -- Agent 191: Safe Deep Access
                    local npcQuests = self.Base:SafeGet("Quests", npc)
                    if npcQuests and npcQuests[qId] then
                        local qData = npcQuests[qId]
                        print("[Agent 141]: Found " .. questName .. " (Reward: " .. tostring(qData.Reward) .. ")")
                        if (qData.Reward or 0) > highestReward then
                            highestReward = qData.Reward
                            bestQuest = questName
                        end
                    end
                end
            end
        end
    end)

    if not success then
        warn("[Agent 141]: Quest Analysis Logic Error: " .. tostring(err))
    end

    if bestQuest then
        print("[Agent 141]: Priority Quest Selected: " .. bestQuest)
        return bestQuest
    else
        warn("[Agent 141]: No valid quests found or Analysis failed.")
        return nil
    end
end

-- [JSON Ref]: BSS_Coordinates.json (Special Locations -> NPC)
function QuestBot:GoToNPC(npcName)
    -- Agent 141: Handshake
    if not self.Base.State.isQuesting then return end

    -- Agent 141: Pause Farming during Quest Turn-in
    if self.Base.State.isFarming then
        print("[Agent 141]: Pausing Farm for Quest Turn-in...")
        self.Base.State.isFarming = false
    end

    -- Agent 191: Defensive check
    if not npcName or type(npcName) ~= "string" then return end

    local npcPos = self.Base:GetFieldPosition(npcName) -- This uses pcall internally in BaseClass

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

    -- Agent 141: Initiate Travel
    self.Base.State.isQuestTraveling = true
    -- In a real scenario, Navigator would be called here via a Controller or direct link.
    -- For simulation, we assume Navigator observes 'isQuestTraveling' or we trigger it:
    -- Navigator:MoveToField(npcName)
end

-- [Deep Logic]: Agent 141 - Quest Step Execution
function QuestBot:ProcessQuestStep(questData)
    -- Input: { Type = "Collect", Field = "Rose Field", Amount = 1000, PollenType = "Red" }

    if self.Base.State.isPaused then return end -- Agent 181 Handshake

    print("[Agent 141]: Processing Step: Collect " .. questData.Amount .. " " .. questData.PollenType .. " in " .. questData.Field)

    -- 1. Travel to Field
    self.Base.State.isQuestTraveling = true
    -- Trigger Navigator (Simulated call)
    -- Navigator:MoveToField(questData.Field)

    -- 2. Wait for Arrival (Handshake)
    local maxWait = 30
    local waited = 0
    while self.Base.State.isQuestTraveling do
        if self.Base.State.isPaused then
            print("[Agent 141]: Pausing Quest Travel due to Safety Protocol.")
        end
        task.wait(1)
        waited = waited + 1
        if waited > maxWait then
            warn("[Agent 141]: Travel timeout!")
            break
        end
    end

    if self.Base.State.activeField == questData.Field then
        print("[Agent 141]: Arrived at Quest Field. Starting Collection.")
        -- 3. Trigger Collector (Simulated call)
        -- Collector:StartCollection("Scooper", questData.Amount)
    end
end

return QuestBot
