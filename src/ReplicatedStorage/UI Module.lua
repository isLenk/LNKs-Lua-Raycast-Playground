local module = {}
local userInputService = game:GetService('UserInputService')
local runService = game:GetService('RunService')

module.BindKeyToUI = function(self, KeyEnum, TargetUI)
	
end

module.BindButtonToUI = function(self, Button, UI)
	Button.MouseButton1Click:Connect(function()
		UI.Visible = not UI.Visible
	end)
end

module.AttachSliderControl = function(self, SliderUI)
	local sliderFrame = SliderUI:FindFirstChild("Slider")
	if not sliderFrame then
		error("Missing 'Slider' Instance: " .. SliderUI:GetFullPath())
	end
	local mouseDown = false
	
	sliderFrame.MouseButton1Down:Connect(function()
		local uiToCursorXOffset = userInputService:GetMouseLocation().x - sliderFrame.AbsolutePosition.X
		mouseDown = true	
		
		local sliderConnection
		sliderConnection = runService.Heartbeat:Connect(function()
			if not mouseDown or not userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then 
				sliderConnection:Disconnect()
			return end
			
			local x = userInputService:GetMouseLocation().x
			local sliderSize = SliderUI.AbsoluteSize.X
			local sliderPos = SliderUI.AbsolutePosition.X
			local xScale = math.clamp((x - sliderPos) / (sliderSize - sliderFrame.Size.X.Offset), 0, 1)
			sliderFrame.Position = UDim2.new(xScale, -uiToCursorXOffset, 0, 0)
		end)
		
	end)
	
	sliderFrame.MouseButton1Up:Connect(function()
		mouseDown = true
	end)
	
end

return module
