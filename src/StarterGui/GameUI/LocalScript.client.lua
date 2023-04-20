local settingsBtn = script.Parent.SettingsButton
local uiModule = require(game.ReplicatedStorage:WaitForChild('UI Module'))
local p = script.Parent

uiModule:BindButtonToUI(p.SettingsButton, p.SettingsInterface)
uiModule:BindButtonToUI(p.SettingsInterface.Camera, p.SettingsInterface.CameraInterface)

local cameraInterface = p.SettingsInterface.CameraInterface
uiModule:AttachSliderControl(cameraInterface.xOffset.SliderBody)
uiModule:AttachSliderControl(cameraInterface.yOffset.SliderBody)
uiModule:AttachSliderControl(cameraInterface.zOffset.SliderBody)
