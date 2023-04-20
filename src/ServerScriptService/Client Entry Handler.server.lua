local characterActionRemote = game.ReplicatedStorage:WaitForChild("CharacterAction").Server
local reloadCharacterRemote = game.ReplicatedStorage:WaitForChild("ReloadCharacter")
local introUI = game.ServerStorage:WaitForChild('IntroUI')

game.Players.PlayerAdded:Connect(function(player)
	characterActionRemote:Fire(player, 'init')	
	
	if workspace:WaitForChild('LOAD_INTRO_IN_STUDIO') then
		if workspace.LOAD_INTRO_IN_STUDIO.Value and game:GetService('RunService'):IsStudio() then
			introUI:Clone().Parent = player.PlayerGui	
		elseif workspace.LOAD_INTRO_IN_STUDIO.Value == false and game:GetService('RunService'):IsStudio() then
			player:LoadCharacter()
		end
	end
	
	if not game:GetService('RunService'):IsStudio() then
		introUI:Clone().Parent = player.PlayerGui	
	end
	
	player.CharacterAdded:wait()
	
	player.CharacterAdded:Connect(function(character)
		characterActionRemote:Fire(player, 'init')	
	end)
end)

game.Players.PlayerRemoving:Connect(function(player)
	characterActionRemote:Fire(player, 'remove')
end)


reloadCharacterRemote.OnServerEvent:Connect(function(player)
	player:LoadCharacter()
end)