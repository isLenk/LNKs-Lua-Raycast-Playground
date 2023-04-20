script.Parent.Enabled = workspace:FindFirstChild("DEBUG_MODE") and workspace.DEBUG_MODE.Value or false

if not game:GetService('RunService'):IsStudio() then
	script.Parent.Enabled = false
end

local debugObjectModel = script.DEBUG_INSTANCE
local frame = script.Parent.Frame

game.ReplicatedStorage.Debugger.Event:Connect(function(debugName, value)
	local debugObject = frame:FindFirstChild(debugName)
	if not debugObject then
		debugObject = debugObjectModel:Clone()
		debugObject.Text = debugName
		debugObject.Name = debugName
		debugObject.Parent = frame
	end
	
	debugObject.LOG.Text = tostring(value)
end)