local cameraModeRemote = game.ReplicatedStorage:WaitForChild('CameraMode')

local character = game.Players.LocalPlayer.Character
local camera = workspace.CurrentCamera
local mouse = game.Players.LocalPlayer:GetMouse()

local userInputService = game:GetService('UserInputService')
local runService = game:GetService('RunService')

--camera.CameraSubject = nil
local root = character.PrimaryPart
local xAngle, yAngle = 0, 0
local limiter = 0.3;
local cameraOffset = Vector3.new(0, 1.35, 10)
local transitionTime = 0.15

local isUsingTrack = false

function calcNewCameraCFrame()
	local cStart = CFrame.new(root.CFrame.p + Vector3.new(0, 2, 0)) * 
		CFrame.Angles(0, math.rad(xAngle), 0) * CFrame.Angles(math.rad(yAngle), 0, 0 )
	local cameraCFrame = cStart + cStart:VectorToWorldSpace(Vector3.new(cameraOffset.X, cameraOffset.Y, cameraOffset.Z))
	local cameraFocus =  cStart + cStart:VectorToWorldSpace(Vector3.new(cameraOffset.X, cameraOffset.Y, -25000))
	
	return CFrame.new(cameraCFrame.p, cameraFocus.p)
end

function handleCamera()
	if not isUsingTrack then return end
	camera.CFrame = calcNewCameraCFrame()
end


function onCameraMode(cameraType)
	if cameraType == 'track' then
		if not isUsingTrack then
			isUsingTrack = true
			camera.CameraType = Enum.CameraType.Scriptable
			userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		end
		
		userInputService.MouseIconEnabled = false
	elseif cameraType == 'default' then
		if isUsingTrack then
			isUsingTrack = false
		end
		
		userInputService.MouseIconEnabled = true
		camera.CameraType = Enum.CameraType.Custom
	end
end

userInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		xAngle = xAngle - input.Delta.x * limiter
		yAngle = math.clamp(yAngle - input.Delta.y* limiter, -80, 80)
	end
end)

cameraModeRemote.Event:Connect(onCameraMode)
runService:BindToRenderStep('track-camera', Enum.RenderPriority.Camera.Value, handleCamera)