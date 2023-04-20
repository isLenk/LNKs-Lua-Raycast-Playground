local ragdollHumanoidRemote = game.ReplicatedStorage:WaitForChild('RagdollHumanoid')
local ragdollHumanoidRemoteSS = ragdollHumanoidRemote.Server

function applyRagdoll(character)
	if character == nil then return end
	for _,v in pairs(character:GetDescendants()) do
		if v:isA("Motor6D") then
			local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
			a0.CFrame = v.C0
			a1.CFrame = v.C1
			a0.Parent = v.Part0
			a1.Parent = v.Part1
			
			local b = Instance.new("BallSocketConstraint")
			b.Attachment0 = a0
			b.Attachment1 = a1
			b.Parent = v.Part0
			v:Destroy()
		end
	end
	character.Humanoid:Destroy()
	local e = Instance.new("Explosion")
	e.Position = character.PrimaryPart.Position
	e.BlastPressure = 2300
	e.BlastRadius = 0
	e.Parent = character.PrimaryPart
end

function setPlayerCG(collisionGroup) 
	for _,v in pairs(script.Parent:GetChildren()) do
		if v:isA("BasePart") then
			game.PhysicsService:SetPartCollisionGroup(v, collisionGroup)
		end
	end
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
		character.Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll, false)
		character.Humanoid.BreakJointsOnDeath = false
		
		setPlayerCG('Player')
		
		character.Humanoid.Died:Connect(function()
			setPlayerCG('Default')
			applyRagdoll(character)
		end)
	end)
end)

function remoteRagdoll(character, e)
	if character == nil or character:FindFirstChild('Ragdoll') or not character:FindFirstChild("Humanoid") then
		return
	end
	
	local ragdollCheck = Instance.new('BoolValue')
	ragdollCheck.Name = 'Ragdoll'
	ragdollCheck.Parent = character
	
	character.Humanoid.BreakJointsOnDeath = false

	
	character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
	character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	
	if (typeof(e) == 'table') then
		if e['Cause'] == 'Dead' then
			--character.Humanoid.Health = 0
		end
	end
	
	applyRagdoll(character)
end

ragdollHumanoidRemote.OnServerEvent:Connect(function(player, character, e)
	remoteRagdoll(character, e)
end)

ragdollHumanoidRemoteSS.Event:Connect(remoteRagdoll)