-- Written by Nahida#5000
-- Game Link: https://www.roblox.com/games/2746687316/Games-Unite-Testing-Place

-- // Settings \\ --
local ESPDistance = 1e3;-- Maximum ESP Distance
local ESPMaxSize = 20;-- Maximum size of the ESP circles (the size depends on how close the players are to you)
-- // Initiation \\ --
local RunService = game:GetService("RunService");
local Camera = game:GetService("Workspace").CurrentCamera;
local PlayerCFrames = {};-- Contains the CFrames of players
local OldDrawings = {};-- Contains the ESP drawings from last frame
-- // Drawing The ESP \\ --
RunService.RenderStepped:Connect(function()
    local OldPlayerCFrames = PlayerCFrames;
    PlayerCFrames = {};
    for _ = 1, #OldDrawings do
        OldDrawings[_] = OldDrawings[_]:Remove() or nil;
    end;
    for _ = 1, #OldPlayerCFrames do
        local Position, OnScreen = Camera:WorldToViewportPoint(OldPlayerCFrames[_].Position);
        if (OnScreen and Position.Z >= 3 and Position.Z <= ESPDistance) then
            local ESP = Drawing.new("Circle");
            ESP.Color = Color3.fromHex("#A5C739");
            ESP.Radius = math.floor(ESPMaxSize - (Position.Z / ESPDistance));
            ESP.Thickness = 2;
            ESP.Position = Vector2.new(Position.X, Position.Y);
            ESP.Visible = true;
            OldDrawings[#OldDrawings+1] = ESP;
        end;
    end;
end);
-- // Grabbing Player CFrames \\ --
local CFN;
CFN = hookfunction(CFrame.new, function(...)
    local CF = CFN(...);
    if ((CF.Position - Camera.CFrame.Position).Magnitude >= 2.5 and CF.Position.Magnitude >= 5) then
        PlayerCFrames[#PlayerCFrames+1] = CF;
    end;
    return CF;
end);
