workspace.CurrentCamera.CFrame = script.CameraCFrame.Value
script.Parent.Enabled = true

local icons = {
	['Hover'] = 'rbxgameasset://Images/Sweat Closeup Look at Screen';
	['Idle'] = 'rbxgameasset://Images/June-RaulByte-Profile-Gifs'
}

local blur = script.Blur
local colorCorrection = script.ColorCorrection

blur.Parent = game.Lighting
colorCorrection.Parent = game.Lighting

script.Parent.StartButton.MouseEnter:Connect(function()
	script.Parent.StartButton.Icon.Image = icons.Hover
end)

script.Parent.StartButton.MouseLeave:Connect(function()
	script.Parent.StartButton.Icon.Image = icons.Idle
end)

script.Parent.StartButton.MouseButton1Click:Connect(function()
	script.Parent.Enabled = false
	game.ReplicatedStorage.ReloadCharacter:FireServer()
	blur:Destroy()
	colorCorrection:Destroy()
	script.Parent:Destroy()
end)