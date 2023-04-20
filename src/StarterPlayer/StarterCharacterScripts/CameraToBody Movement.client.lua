local character = game.Players.LocalPlayer.Character
local camera = workspace.CurrentCamera
local n = character.Head.Neck
local cyo = n.C0.Y

game:GetService('RunService').Heartbeat:Connect(function()
	local cDir = character.PrimaryPart.CFrame:toObjectSpace(camera.CFrame).lookVector
	n.C0 = CFrame.new(0, cyo, 0) * CFrame.Angles(math.asin(cDir.y), -math.asin(cDir.x), 0)
end)