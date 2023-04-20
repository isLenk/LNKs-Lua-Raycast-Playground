local characterActionRemote = game.ReplicatedStorage:WaitForChild('CharacterAction')

local csPlayerAssetsFolder = game.ReplicatedStorage:WaitForChild("Player Assets")
local localPlayer = game.Players.LocalPlayer

function getAssetsFolder(player)
	return csPlayerAssetsFolder:FindFirstChild('user-' .. player.userId)
end

function doFrontflipEffect(player)
	local character = player.Character
	local explosion = Instance.new("Explosion")
	explosion.Position = character:GetPrimaryPartCFrame().p
	explosion.DestroyJointRadiusPercent = 0
	explosion.BlastRadius = 10
	explosion.Parent = character.PrimaryPart
	
	if player == localPlayer then
		explosion.Hit:Connect(function(part)
		local modelParent = part:FindFirstAncestorOfClass("Model")
		if modelParent and modelParent ~= character and part == modelParent.PrimaryPart then
			game.ReplicatedStorage.RagdollHumanoid.Server:Fire(modelParent, {['Cause'] = 'Dead'})
		end				
	end)
	end
end

function doDashPunchEffect(player, e)
	local assets = getAssetsFolder(player)
	local character = player.Character
	local punchTrail = assets['PunchTrail'].Value
	
	if punchTrail == nil then print('Punch Trail Missing') return end
	punchTrail.Enabled = true
	delay(e.ANIMATION_LENGTH * 0.25, function()
		local connection
		connection = character.RightHand.Touched:Connect(function(targetHit)
			local targetParent = targetHit:FindFirstAncestorOfClass('Model')
			if targetParent and targetParent:FindFirstChild('Humanoid') and targetParent.PrimaryPart == targetHit then	
				local exp = Instance.new("Explosion")
					exp.Position = targetParent:GetPrimaryPartCFrame().p
					exp.DestroyJointRadiusPercent = 0
					exp.Parent = targetParent				
					
				game.ReplicatedStorage.RagdollHumanoid:FireServer(targetParent, {['Cause'] = 'Dead'})
			end
			if targetParent and targetParent.Parent.Name == 'Destructable' then
				if targetParent.Name:find("Explosive") then
					local exp = Instance.new("Explosion")
					exp.Position = targetParent:GetPrimaryPartCFrame().p
					exp.DestroyJointRadiusPercent = 0
					exp.Parent = targetParent				
					
				end
				for _,v in pairs(targetParent:GetDescendants()) do
					if v:isA('BasePart') then
						v.Anchored = false
						delay(3, function()
							for i = 0, 10 do
								v.Transparency = i
								wait(0.1)
							end
							v:Destroy()
						end)
					end
				end
			end
			
		end)
		delay(0.2, function()
			punchTrail.Enabled = false
			connection:Disconnect()
		end)
	end)
end

characterActionRemote.OnClientEvent:Connect(function(player, request, e)
	if request == 'FRONT_FLIP' then
		doFrontflipEffect(player)
	elseif request == 'DASH_PUNCH' then
		doDashPunchEffect(player, e)
	end
end)