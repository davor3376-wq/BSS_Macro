-- [Guild Reference]: Guild D - The Slayers
-- [Primary Coder]: Agent 101 (Combat Lead)
-- [QA Verified By]: Agent 130 (Mob Sweeper)
-- [JSON Ref]: Aegis_Ultimate_Manifest.json & BSS_Coordinates.json

--[[
    IDENTITY INITIALIZATION:
    I am Agent 101, the Combat Lead. I govern all mob interactions.
    I manage the health, respawn timers, and combat positioning for every enemy in the game, from Ladybugs to the Coconut Crab.

    ROLE AWARENESS:
    I calculate the 'Damage Per Second' (DPS) required to defeat mobs before they damage the player.
    I use circle-strafe logic (for the Crab) and AFK positioning (for the Snail) based on 'BSS_Coordinates.json'.

    CROSS-AGENT DEBATE (Simulated):
    ---------------------------------------------------------------------------------------------------------
    [Agent 101 - Combat Lead]: "I see a 'Commando Chick' level 50. I will approach and attack."

    [Agent 188 - Logic Debater (Guild F)]: "Wait! Your Vicinity check is off. The Commando Chick throws bombs.
                                            You will die in 2 hits. You must strafe."

    [Agent 101 - Combat Lead]: "Strafing uses 30% more CPU on mobile. Can I just tank the hits with a precise heal?"

    [Agent 188 - Logic Debater]: "No. That relies on network latency. If ping > 100ms, you die.
                                  Use the 'Commando Chick' specialized movement pattern: Tween away
                                  when the bomb lands, tween back when it explodes."

    [Agent 101 - Combat Lead]: "Accepted. I will query 'Mob HP' from the Manifest first to gauge difficulty."
    ---------------------------------------------------------------------------------------------------------
]]

local Slayer = {}
Slayer.__index = Slayer

function Slayer.new(baseClassInstance)
    local self = setmetatable({}, Slayer)
    self.Base = baseClassInstance
    self.ActiveTarget = nil
    return self
end

-- [JSON Ref]: Aegis_Ultimate_Manifest.json (Mobs)
function Slayer:IdentifyTarget(mobName)
    local mobStats = self.Base.Cache.Manifest.Mobs[mobName]

    if not mobStats then
        warn("[Agent 101]: Unknown mob type: " .. tostring(mobName))
        return nil
    end

    print("[Agent 101]: Targeted " .. mobName .. " (HP: " .. mobStats.HP .. ", Level: " .. mobStats.Level .. ")")
    self.ActiveTarget = mobName
    return mobStats
end

-- [JSON Ref]: BSS_Coordinates.json (Special Locations -> Commando Chick)
function Slayer:CombatLoop()
    if not self.ActiveTarget then return end

    local stats = self.Base.Cache.Manifest.Mobs[self.ActiveTarget]

    -- Special Logic for Bosses
    if self.ActiveTarget == "CoconutCrab" then
        -- Execute Agent 102's Circle Strafe Logic
        print("[Agent 102]: Initiating Circle Strafe around Coconut Field...")
        -- In a real script: local center = Vector3.new(...)
        -- self.Navigator:Circle(center, radius=30)
    elseif self.ActiveTarget == "StumpSnail" then
        -- Execute Agent 103's AFK Logic
        print("[Agent 103]: Positioning on top of Stump Field for AFK kill...")
        -- self.Navigator:MoveTo(Vector3.new(422.69, 105.00, -174.36))
    else
        -- General Mob Logic (Agent 121)
        print("[Agent 121]: Engaging " .. self.ActiveTarget .. " with standard attacks.")
    end
end

return Slayer
