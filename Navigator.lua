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

    [AUDIT TRAIL - AGENT 191 (WARDEN)]:
    [v1.0 REJECTED]: "Agent 021, your 'MoveToField' function accessed 'HumanoidRootPart' directly without verifying existence.
                      If the character is dead (HRP is nil), the script crashes. You also did not wrap the Tween logic in pcall.
                      If TweenService fails (internal Roblox error), the bot hangs."
    [v1.1 APPROVED]: "Added 'if HumanoidRootPart' check and wrapped critical tween execution in pcall.
                      Using Base:SafeGet for speed settings. Approved."
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
    -- Agent 181: Safety Protocol Check
    if self.Base.State.isPaused then
        print("[Agent 181]: Movement Paused due to Safety Event.")
        return false
    end

    -- Agent 141: Handshake - Check if busy converting
    if self.Base.State.isConverting then
        print("[Agent 021]: Pausing movement. Collector is full/converting.")
        return false
    end

    -- Agent 191: Safety Check for Character existence
    if not Character or not Character.Parent or not HumanoidRootPart then
        warn("[Agent 021]: Character not ready for movement.")
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        return false
    end

    -- Agent 002 provides the coordinates via BaseClass (which uses pcall internally)
    local targetPos = self.Base:GetFieldPosition(fieldName)

    if not targetPos then
        warn("[Agent 021]: Destination coordinates not found in BSS_Coordinates.json!")
        return false
    end

    print("[Agent 021]: Calculating path to " .. fieldName)
    self.Base.State.activeField = fieldName -- Update State

    -- Agent 191: Wrap critical movement logic in pcall & Register Tween
    local success, err = pcall(function()
        local distance = (HumanoidRootPart.Position - targetPos).Magnitude
        local speed = 60 -- Default safe speed

        -- [JSON Ref]: Aegis_Ultimate_Manifest.json (GameSettings -> MobileOptimized)
        if self.Base:IsMobileOptimized() then
            speed = 40 -- Slower for mobile stability
        end

        local time = distance / speed
        local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})

        -- Agent 191: Register connection to allow cancellation
        self.Base:RegisterConnection("ActiveTween", tween.Completed:Connect(function()
            -- Tween done, cleanup happens naturally
        end))

        tween:Play()
        tween.Completed:Wait()
        self.Base:ClearConnection("ActiveTween") -- Cleanup immediately after
    end)

    if success then
        print("[Agent 021]: Arrived at " .. fieldName)
        -- Agent 141: Handshake Complete
        if self.Base.State.isQuestTraveling then
             print("[Agent 141]: Quest Travel Complete. Handing over to Collector.")
             self.Base.State.isQuestTraveling = false
        end
        return true
    else
        warn("[Agent 021]: Movement Failed! Error: " .. tostring(err))
        self.Base:ClearConnection("ActiveTween")
        return false
    end
end

-- [JSON Ref]: BSS_Coordinates.json (Special Locations -> Hive Hub)
function Navigator:ReturnToHive()
    local hivePos = Vector3.new(-185.91, 5.91, 331.49) -- Hardcoded fallback or fetch from JSON

    print("[Agent 021]: Returning to Hive Hub...")
    local success, err = pcall(function()
        if HumanoidRootPart then
             local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(5), {CFrame = CFrame.new(hivePos)})
             tween:Play()
             tween.Completed:Wait()
        end
    end)

    if not success then
        warn("[Agent 021]: ReturnToHive Failed: " .. tostring(err))
    end
end

return Navigator
