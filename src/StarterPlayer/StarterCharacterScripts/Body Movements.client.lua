-- Prototype, dirty-fix

-- Configuration
local keybinds = {
	['FRONT_FLIP'] = Enum.KeyCode.X;
	['DASH_PUNCH'] = Enum.KeyCode.F;
	['RUN'] = Enum.KeyCode.LeftShift;
}

local player = game.Players.LocalPlayer
local character = player.Character

local wallrunRemote = game.ReplicatedStorage.Wallrun
local characterActionRemote = game.ReplicatedStorage.CharacterAction
local cameraModeRemote = game.ReplicatedStorage.CameraMode

local frontflipAnim = Instance.new("Animation")
frontflipAnim.AnimationId = "rbxassetid://5318366028"

local punchAnim = Instance.new("Animation")
punchAnim.AnimationId = "rbxassetid://5318544660"

local runAnim = Instance.new("Animation")
runAnim.AnimationId = "rbxassetid://5325155920"

local doubleJumpAnim = Instance.new("Animation")
doubleJumpAnim.AnimationId = "rbxassetid://5326265636"

local verticalWallRunAnim = Instance.new("Animation")
verticalWallRunAnim.AnimationId = "rbxassetid://5331866285"

local frontflipAnimationTrack = character.Humanoid:LoadAnimation(frontflipAnim)
local punchAnimationTrack = character.Humanoid:LoadAnimation(punchAnim)
local runAnimationTrack = character.Humanoid:LoadAnimation(runAnim)
local doubleJumpAnimationTrack = character.Humanoid:LoadAnimation(doubleJumpAnim)
local verticalWalRunAnimationTrack = character.Humanoid:LoadAnimation(verticalWallRunAnim)

local bodyMover = Instance.new("BodyVelocity")

local maxJumps = 2
local jumpsUsed = maxJumps

game:GetService("UserInputService").InputEnded:Connect(function(key)
	-- Power front flip
	if key.KeyCode == keybinds.FRONT_FLIP and not frontflipAnimationTrack.IsPlaying then
		character.Humanoid.Jump = true

		local targetLocation = character.PrimaryPart.CFrame.LookVector * 150--character:GetPrimaryPartCFrame() * CFrame.new(-1, 0, 0) * 		CFrame.new(0, 0, -220)
		bodyMover.Velocity = targetLocation
		bodyMover.P = 5000
		bodyMover.MaxForce = Vector3.new(math.huge,0, math.huge)
		bodyMover.Parent = character.PrimaryPart
		frontflipAnimationTrack:Play(0.1, 1, 1.5)
		
		delay(frontflipAnimationTrack:GetTimeOfKeyframe("BeginJump"), function()
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			characterActionRemote:FireServer('FRONT_FLIP')
		end)
		
		frontflipAnimationTrack.Stopped:Wait()
		bodyMover.Parent = nil
	end
	
	-- Run
	if key.KeyCode == keybinds.RUN then
		character.Humanoid.WalkSpeed = game.StarterPlayer.CharacterWalkSpeed
		runAnimationTrack:Stop()
		cameraModeRemote:Fire('default')
	end
	
	if key.KeyCode == Enum.KeyCode.LeftShift then
		if character.PrimaryPart:FindFirstChild('wr')  then
			character.PrimaryPart.wr:Destroy()
			local cCFrame = character:GetPrimaryPartCFrame()
			character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			local bodyForce = Instance.new("BodyForce")
			bodyForce.Force = cCFrame.lookVector * -5250
			bodyForce.Parent = character.PrimaryPart
			game.Debris:AddItem(bodyForce, 0.25)
			verticalWalRunAnimationTrack:Stop()
			doubleJumpAnimationTrack:Play()
		end
	end

end)


game:GetService('UserInputService').InputBegan:Connect(function(key)
	-- Run
	if key.KeyCode == keybinds.RUN then
		cameraModeRemote:Fire('track')
		character.Humanoid.WalkSpeed *= 3
		runAnimationTrack:Play()
	end
	
		-- Double Jump
	if key.KeyCode == Enum.KeyCode.Space then
		-- Stop the run animation until the player lands
		runAnimationTrack:Stop()
		delay(0.2, function()
			-- Check to see if we should continue the running animation after they land
			local material = character.Humanoid:GetPropertyChangedSignal('FloorMaterial'):wait()
			if material ~= Enum.Material.Air and game:GetService('UserInputService'):IsKeyDown(Enum.KeyCode.LeftShift) then
				runAnimationTrack:Play()
			end			
		end)
		
		if jumpsUsed > 0 then
			if jumpsUsed == maxJumps then jumpsUsed -= 1 return end
			jumpsUsed -= 1
			doubleJumpAnimationTrack:Play()
			character.Humanoid.JumpPower *= 1.55
			character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			character.Humanoid.JumpPower /= 1.55
			jumpsUsed = maxJumps
		end
	end
	
end)


local punchBm = Instance.new("BodyVelocity")
local mouse = player:GetMouse()

mouse.Button1Down:Connect(function()
	if not game:GetService('UserInputService'):IsKeyDown(keybinds.DASH_PUNCH) then return end
	punchAnimationTrack:Play(0.1 , 1, 1.5)
	
	local targetLocation = character.PrimaryPart.CFrame.LookVector * 100
	punchBm.Velocity = targetLocation
	punchBm.P = 50200
	punchBm.MaxForce = Vector3.new(math.huge,0, math.huge)
	punchBm.Parent = character.HumanoidRootPart
	
	characterActionRemote:FireServer('DASH_PUNCH', {['ANIMATION_LENGTH']=punchAnimationTrack.Length})
	
	punchAnimationTrack.Stopped:Wait()
	punchBm.Parent = nil
end)

wallrunRemote.Event:Connect(function(action, wall, position)
	if action == 'stop' then
		local a = character.PrimaryPart:FindFirstChild('wr')
		if verticalWalRunAnimationTrack.IsPlaying then
			verticalWalRunAnimationTrack:Stop()
			doubleJumpAnimationTrack:Play()
		end
		if a then a:Destroy() end
		return
	end
	if character.PrimaryPart:FindFirstChild('wr') then
	return end
	
	local bm = Instance.new("BodyVelocity")
	bm.Name = 'wr'
	
	local targetLocation = character.PrimaryPart.CFrame + character.PrimaryPart.CFrame.UpVector * 45
	
	bm.Velocity = targetLocation.Position
	bm.P = 50200
	bm.MaxForce = Vector3.new(0 ,math.huge,0)
	bm.Parent = character.PrimaryPart
	runAnimationTrack:Stop()
	verticalWalRunAnimationTrack:Play(0.1, 1, 1.5)
end)

