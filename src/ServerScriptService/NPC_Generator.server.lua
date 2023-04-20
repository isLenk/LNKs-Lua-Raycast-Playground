
local humanoidDescriptionContent= {
	['Shirt'] = {
	682219228,682219340, 682219017, 682219856, 682220708, 682223194, 3314855014};
	
	['Pants'] = {
	3914575518,5326149867, 5053949817, 5329459139, 5329184075, 5147645127, 2665843588, 5293230340
	};
	
	['Face'] = {
	133360789, 8329686, 25166274, 20418658, 8329679, 20722130, 26424808, 2222771916
	};
	
	['FaceAccessory'] = {
	4713293323, 5313561767, 4904137145, 4904153006, 4466228735, 4772327953, 4197739997
	};
	
	['HairAccessory'] = {
	5099762304, 5317734007, 4904074569, 5099774650, 5067664762, 4684968628, 5314006793, 5064651922
	}
	
}

local npcModel = game.ReplicatedStorage:WaitForChild("NpcModel")
local populationCap = 20
local npcFolder = workspace.NPC_LIST

function generateHumanoidDescription()
	local humanoidDescription = Instance.new("HumanoidDescription")
	for propertyName, options in pairs(humanoidDescriptionContent) do
		humanoidDescription[propertyName] = options[math.random(#options)]
	end
	
	humanoidDescription.HeadColor = Color3.fromRGB(255, 204, 153)
	humanoidDescription.LeftArmColor = Color3.fromRGB(255, 204, 153)
	humanoidDescription.RightArmColor = Color3.fromRGB(255, 204, 153)
	humanoidDescription.RightLegColor = Color3.fromRGB(255, 204, 153)
	humanoidDescription.LeftLegColor = Color3.fromRGB(255, 204, 153)
	humanoidDescription.TorsoColor = Color3.fromRGB(255, 204, 153)
	return humanoidDescription
end

for npcIndex = 0, populationCap do
	local npc = npcModel:Clone()
	npc.Parent = npcFolder
	local wx = workspace.Baseplate.Size.X
	local wz = workspace.Baseplate.Size.Z
	npc:SetPrimaryPartCFrame(CFrame.new(workspace.Baseplate.Position + Vector3.new(math.random(-wx / 2, wx /2), 150, math.random(-wz / 2, wz /2))))
	
	npc.Humanoid:ApplyDescription(generateHumanoidDescription())
	wait(0.15)
end

local npcList = {}
for _,v in pairs(npcFolder:GetChildren()) do
	if v:isA('Model') and v:FindFirstChild("Humanoid") then
		table.insert(npcList, v)
		
		spawn(function()
			while wait(math.random(2, 5)) do
				if v:FindFirstChild("Humanoid") and v.PrimaryPart then
					v.Humanoid:MoveTo(v:GetPrimaryPartCFrame().p + Vector3.new(math.random(-50, 50),0, math.random(-50, 50)))
				end
			end
		end)
		
	end
end
