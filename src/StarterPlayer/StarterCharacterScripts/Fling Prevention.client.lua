local character = game.Players.LocalPlayer.Character


local lastLoggedPos = character:GetPrimaryPartCFrame()
local timePerCheck = 2
local timeSinceLastCheck = timePerCheck

local capDistance = 300

game:GetService('RunService').Heartbeat:Connect(function(step)
	if character:GetPrimaryPartCFrame().p.Y < -100 then
		game.ReplicatedStorage.ReloadCharacter:FireServer()
	end
	timeSinceLastCheck -= step
	if timeSinceLastCheck <= 0 then
		timeSinceLastCheck = timePerCheck
		local travelDistance = (lastLoggedPos.p - character:GetPrimaryPartCFrame().p).magnitude
		print('Distance Travelled in Period: ' .. travelDistance)
		
		if travelDistance > capDistance then
			print("Potential Fling Detected: Returning to last logged position")
			character:SetPrimaryPartCFrame(lastLoggedPos * CFrame.new(0, 2, 0))
			character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
		end
		lastLoggedPos = character:GetPrimaryPartCFrame() 
	end
end)