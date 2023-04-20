local characterAction = game.ReplicatedStorage:WaitForChild('CharacterAction')

local ssPlayerAssetsFolder = game.ServerStorage:WaitForChild('Player Assets')
local csPlayerAssetsFolder = game.ReplicatedStorage:WaitForChild("Player Assets")

local defaultAssets = {
	['PUNCH_TRAIL'] = ssPlayerAssetsFolder.PunchTrail
}

function createAssetReference(assetFolder, asset) 
	local objectValue = assetFolder:FindFirstChild(asset.Name)
	if not objectValue then
		objectValue = Instance.new("ObjectValue")
		objectValue.Name = asset.Name
		objectValue.Parent = assetFolder
	end
	objectValue.Value = asset
end

function initializePlayerAssets(player)
	local character = player.Character or player.CharacterAdded:wait()
	
	local clientAssetFolder = getAssetsFolder(player)
	if not clientAssetFolder then
		clientAssetFolder = Instance.new("Folder")
		clientAssetFolder.Name = 'user-' .. player.userId
		clientAssetFolder.Parent = csPlayerAssetsFolder
		print("Initialized Asset Folder - PLAYER " .. player.userId)
	end
	
	local punchTrail = defaultAssets.PUNCH_TRAIL:Clone()
	punchTrail.Attachment0 = character.RightHand.RightWristRigAttachment
	punchTrail.Attachment1 = character.RightUpperArm.RightElbowRigAttachment
	punchTrail.Enabled = false
	punchTrail.Parent = character.PrimaryPart
	
	createAssetReference(clientAssetFolder, punchTrail)
end

function removePlayerAssetFolder(player)
	getAssetsFolder(player):Destroy()
end

function getAssetsFolder(player)
	return csPlayerAssetsFolder:FindFirstChild('user-' .. player.userId)
end


characterAction.OnServerEvent:Connect(function(player, request, eventData)
	if request == 'FRONT_FLIP' then
		characterAction:FireAllClients(player, request)
	elseif request == 'DASH_PUNCH' then
		characterAction:FireAllClients(player, request, eventData)
	end
end)

characterAction.Server.Event:Connect(function(player, request)
	if request == 'init' then
		initializePlayerAssets(player)
	elseif request == 'remove' then
		removePlayerAssetFolder(player)
	end
end)