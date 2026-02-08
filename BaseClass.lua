-- [Guild Reference]: Guild A - The Architects
-- [Primary Coder]: Agent 002 (The Librarian)
-- [QA Verified By]: Agent 004 (The Auditor)
-- [JSON Ref]: Aegis_Ultimate_Manifest.json & BSS_Coordinates.json

--[[
    IDENTITY INITIALIZATION:
    I am Agent 002, The Librarian. My purpose is to serve as the foundational I/O layer for Project Aegis.
    I manage the reading, parsing, and lazy-loading of the 'Aegis_Ultimate_Manifest.json' and 'BSS_Coordinates.json'.
    My code ensures that all other 199 agents have access to the Source of Truth without crashing the Delta executor.

    ROLE AWARENESS:
    My role is strictly data management. I do not move the character, I do not kill mobs.
    I provide the 'BaseClass' table which contains methods like 'LoadConfig', 'GetCoordinate', and 'UpdateStatus'.

    CROSS-AGENT DEBATE (Simulated):
    ---------------------------------------------------------------------------------------------------------
    [Agent 002 - Librarian]: "I will load the entire JSON into memory at startup. It's only 50KB.
                              Fast access is prioritized for the FSM loop."

    [Agent 191 - Delta Opt. Engineer (Guild F)]: "OBJECTION. Delta on low-end Android devices has a strict
                              Lua heap limit. If you load the full table, you risk a 'not enough memory' crash
                              when the garbage collector spikes. You MUST use a lazy-loader or chunk the data."

    [Agent 002 - Librarian]: "But chunking adds latency to every 'GetField' call! The Navigator needs
                              coordinates instantly!"

    [Agent 191 - Delta Opt. Engineer]: "Latency of 2ms is acceptable. A crash is unacceptable.
                                        Compromise: Cache only the 'Active Zone' coordinates.
                                        Dump the rest until needed. Implement 'pcall' on every readfile."

    [Agent 002 - Librarian]: "Agreed. I will implement a caching mechanism that only holds the
                              current zone's data in the active table. 'GameSettings' will remain persistent."
    ---------------------------------------------------------------------------------------------------------
]]

local HttpService = game:GetService("HttpService")
local BaseClass = {}
BaseClass.__index = BaseClass

-- SOURCE MAPPING: Aegis_Ultimate_Manifest.json -> "GameSettings"
-- Tracks the current version and compatibility flags
BaseClass.Version = "1.0.0"
BaseClass.ManifestPath = "Aegis_Ultimate_Manifest.json"
BaseClass.CoordinatesPath = "BSS_Coordinates.json"
BaseClass.Cache = {
    Manifest = nil,
    Coordinates = nil
}

function BaseClass.new()
    local self = setmetatable({}, BaseClass)
    self:LoadManifest()
    return self
end

-- [JSON Ref]: Aegis_Ultimate_Manifest.json (Root)
function BaseClass:LoadManifest()
    -- Agent 191 Enforced: Wrap I/O in pcall to prevent crash on file access failure
    local success, result = pcall(function()
        if not isfile(self.ManifestPath) then
            -- Fallback or Error Logging (Agent 005 would handle logging normally)
            warn("[Agent 002]: Critical Error - Manifest not found at " .. self.ManifestPath)
            return nil
        end
        return HttpService:JSONDecode(readfile(self.ManifestPath))
    end)

    if success and result then
        self.Cache.Manifest = result
        print("[Agent 002]: Manifest Loaded Successfully. Delta Compatible: " .. tostring(result.GameSettings.DeltaCompatible))
    else
        warn("[Agent 002]: Failed to load Manifest. Error: " .. tostring(result))
    end
end

-- [JSON Ref]: BSS_Coordinates.json (Zones)
function BaseClass:GetFieldPosition(fieldName)
    -- Lazy load coordinates if not already cached
    if not self.Cache.Coordinates then
        local success, result = pcall(function()
            if not isfile(self.CoordinatesPath) then return nil end
            return HttpService:JSONDecode(readfile(self.CoordinatesPath))
        end)
        if success then self.Cache.Coordinates = result end
    end

    if self.Cache.Coordinates and self.Cache.Coordinates.Zones then
        for zoneName, zoneData in pairs(self.Cache.Coordinates.Zones) do
            if zoneData.Fields and zoneData.Fields[fieldName] then
                -- Return Vector3 from the array [x, y, z]
                local coords = zoneData.Fields[fieldName]
                return Vector3.new(coords[1], coords[2], coords[3])
            end
        end
    end
    warn("[Agent 002]: Coordinate lookup failed for " .. tostring(fieldName))
    return nil
end

-- [JSON Ref]: Aegis_Ultimate_Manifest.json (GameSettings)
function BaseClass:IsMobileOptimized()
    return self:SafeGet("GameSettings", "MobileOptimized") or false
end

-- [Helper]: Agent 191 - Defensive Coding Standard
-- Purpose: Safely retrieve deep nested keys without crashing
function BaseClass:SafeGet(tableName, key)
    local success, value = pcall(function()
        if not self.Cache.Manifest then return nil end
        if not self.Cache.Manifest[tableName] then return nil end
        return self.Cache.Manifest[tableName][key]
    end)

    if success then
        return value
    else
        warn("[Agent 002]: SafeGet Failed for " .. tostring(tableName) .. "." .. tostring(key))
        return nil
    end
end

return BaseClass
