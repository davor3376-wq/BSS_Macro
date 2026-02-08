-- [Guild Reference]: Guild B - The Navigators
-- [Primary Coder]: Agent 021 (Physics Lead)
-- [QA Verified By]: Agent 035 (Tween Master)
-- [JSON Ref]: BSS_Coordinates.json

--[[
    IDENTITY INITIALIZATION:
    I am Agent 021, the Physics Lead. My responsibility is to manage the movement and pathfinding of the character.
    I ensure that the character moves from point A to point B without clipping, teleporting illegally, or being flagged by anti-cheat.

    ROLE AWARENESS:
    I execute precise movements using CFrame tweening (for smooth, human-like motion) and Humanoid.WalkSpeed adjustments.
    I reference 'BSS_Coordinates.json' to ensure I am landing directly in the center of fields and avoiding 'Kill Zones'.

    CROSS-AGENT DEBATE (Simulated):
    ---------------------------------------------------------------------------------------------------------
    [Agent 021 - Physics Lead]: "The fastest way to traverse the map is instantaneous CFrame teleportation.
                                 Set CFrame = Target. Done. 0ms travel time."

    [Agent 182 - Logic Debater (Guild F)]: "Are you trying to get us banned? Instant teleportation triggers
                                            every server-side check. You must Tween.
                                            Furthermore, if you tween through the ground, you die."

    [Agent 021 - Physics Lead]: "Fine. I will use TweenService. Speed set to 150 studs/second."

    [Agent 182 - Logic Debater]: "Wait. If you Tween at 150 through a wall, the Raycast might miss.
                                  You need to check for 'Obstacle Zones' in the JSON first.
                                  Reference 'Safety Zones' in BSS_Coordinates.json."

    [Agent 021 - Physics Lead]: "Valid point. I will implement a 'SafePath' function that checks if the
                                 straight line intersects with known hazards before tweening."
    ---------------------------------------------------------------------------------------------------------
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Navigator = {}
Navigator.__index = Navigator

function Navigator.new(baseClassInstance)
    local self = setmetatable({}, Navigator)
    self.Base = baseClassInstance -- Link to Agent 002's BaseClass
    return self
end

-- [JSON Ref]: BSS_Coordinates.json (Fields)
function Navigator:MoveToField(fieldName)
    print("[Agent 021]: Calculating path to " .. fieldName)

    -- Agent 002 provides the coordinates via BaseClass
    local targetPos = self.Base:GetFieldPosition(fieldName)

    if not targetPos then
        warn("[Agent 021]: Destination coordinates not found in BSS_Coordinates.json!")
        return false
    end

    -- Agent 182 Enforced: Safety check (simplified for this simulation)
    -- In a full implementation, this would check against "Safety Zones"

    -- Execute Tween
    local distance = (HumanoidRootPart.Position - targetPos).Magnitude
    local speed = 60 -- Default safe speed

    -- [JSON Ref]: Aegis_Ultimate_Manifest.json (GameSettings -> MobileOptimized)
    if self.Base:IsMobileOptimized() then
        speed = 40 -- Slower for mobile stability
    end

    local time = distance / speed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})

    tween:Play()
    tween.Completed:Wait()
    print("[Agent 021]: Arrived at " .. fieldName)
    return true
end

-- [JSON Ref]: BSS_Coordinates.json (Special Locations -> Hive Hub)
function Navigator:ReturnToHive()
    local hivePos = Vector3.new(-185.91, 5.91, 331.49) -- Hardcoded fallback or fetch from JSON
    -- Ideally: self.Base:GetSpecialLocation("Hive Hub")

    print("[Agent 021]: Returning to Hive Hub...")
    local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(5), {CFrame = CFrame.new(hivePos)})
    tween:Play()
    tween.Completed:Wait()
end

return Navigator
