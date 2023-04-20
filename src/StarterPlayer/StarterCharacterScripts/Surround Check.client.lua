local character = game.Players.LocalPlayer.Character

local rayVisualizer = Instance.new('Part')
rayVisualizer.Name = 'Ray Visualizer'
rayVisualizer.BrickColor = BrickColor.Green()
rayVisualizer.Transparency = 0.5
rayVisualizer.CanCollide = false
rayVisualizer.Anchored = true

local showRay = false
function visualizeRay(origin, endPoint)
	if not showRay then return end
	rayVisualizer.Size = Vector3.new(0.25 ,0.25, (origin - endPoint).magnitude) 
	rayVisualizer.CFrame = CFrame.new(endPoint + (origin - endPoint)/2, endPoint)
	rayVisualizer.Parent = workspace
end


game:GetService('RunService').Heartbeat:Connect(function()
	local charCFrame = character.PrimaryPart.CFrame
	local rayOrigin = charCFrame.p
	local rayDistance = 10
	
	local LEFT_RAY_DIR = -charCFrame.RightVector * rayDistance
	local RIGHT_RAY_DIR = charCFrame.RightVector * rayDistance
	local UP_RAY_DIR = charCFrame.LookVector * rayDistance
	local UPLEFT_RAY_DIR = (charCFrame.LookVector - charCFrame.RightVector) * rayDistance
	local UPRIGHT_RAY_DIR = (charCFrame.RightVector + charCFrame.LookVector) * rayDistance
	
	-- Limit Distance
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {character, rayVisualizer}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	
	local LEFT_RAY_RESULT = workspace:Raycast(rayOrigin, LEFT_RAY_DIR, raycastParams)
	local RIGHT_RAY_RESULT = workspace:Raycast(rayOrigin, RIGHT_RAY_DIR, raycastParams)
	local UP_RAY_RESULT = workspace:Raycast(rayOrigin, UP_RAY_DIR, raycastParams)
	local UPLEFT_RAY_RESULT = workspace:Raycast(rayOrigin, UPLEFT_RAY_DIR, raycastParams)
	local UPRIGHT_RAY_RESULT = workspace:Raycast(rayOrigin, UPRIGHT_RAY_DIR, raycastParams)
	
	local CLOSEST_RAY = nil
	local RAY_INITIAL = ''
	local CLOSEST_RAY_MAGNITUDE = rayDistance
	
	
	if LEFT_RAY_RESULT then
		local rayMagnitude = (rayOrigin - LEFT_RAY_RESULT.Position).magnitude
		if rayMagnitude < CLOSEST_RAY_MAGNITUDE then
			CLOSEST_RAY = LEFT_RAY_RESULT
			RAY_INITIAL = "L"
			CLOSEST_RAY_MAGNITUDE = rayMagnitude
		end
	end
		
	if RIGHT_RAY_RESULT then
		local rayMagnitude = (rayOrigin - RIGHT_RAY_RESULT.Position).magnitude
		if rayMagnitude < CLOSEST_RAY_MAGNITUDE then
			CLOSEST_RAY = RIGHT_RAY_RESULT
			RAY_INITIAL = "R"
			CLOSEST_RAY_MAGNITUDE = rayMagnitude
		end
	end
	
	if UP_RAY_RESULT then
		local rayMagnitude = (rayOrigin - UP_RAY_RESULT.Position).magnitude
		if rayMagnitude < CLOSEST_RAY_MAGNITUDE then
			CLOSEST_RAY = UP_RAY_RESULT
			RAY_INITIAL = "U"
			CLOSEST_RAY_MAGNITUDE = rayMagnitude
		end
	end
	
	if UPLEFT_RAY_RESULT then
		local rayMagnitude = (rayOrigin - UPLEFT_RAY_RESULT.Position).magnitude
		if rayMagnitude < CLOSEST_RAY_MAGNITUDE then
			CLOSEST_RAY = UPLEFT_RAY_RESULT
			RAY_INITIAL = "UL"
			CLOSEST_RAY_MAGNITUDE = rayMagnitude
		end
	end
	
	if UPRIGHT_RAY_RESULT then
		local rayMagnitude = (rayOrigin - UPRIGHT_RAY_RESULT.Position).magnitude
		if rayMagnitude < CLOSEST_RAY_MAGNITUDE then
			CLOSEST_RAY = UPRIGHT_RAY_RESULT
			RAY_INITIAL = "UR"
			CLOSEST_RAY_MAGNITUDE = rayMagnitude
		end
	end
		
	if CLOSEST_RAY == nil then
		game.ReplicatedStorage.Debugger:Fire('RAY RESULT', 'NONE')
		
		game.ReplicatedStorage.Wallrun:Fire('stop')
		rayVisualizer.Parent = nil
	else 
		game.ReplicatedStorage.Debugger:Fire('RAY RESULT', RAY_INITIAL .. ': ' .. (rayOrigin - CLOSEST_RAY.Position).magnitude)
		local modelParent = CLOSEST_RAY.Instance:FindFirstAncestorOfClass('Model')
		if modelParent and modelParent.Name:find('Platform') then
			visualizeRay(rayOrigin, CLOSEST_RAY.Position)
		end
		
		-- Attempt wall run
		if CLOSEST_RAY_MAGNITUDE < 4 and game:GetService('UserInputService'):IsKeyDown(Enum.KeyCode.LeftShift) then
			game.ReplicatedStorage.Wallrun:Fire('', CLOSEST_RAY.Instance, CLOSEST_RAY.Position)
		end
	end
	
end)