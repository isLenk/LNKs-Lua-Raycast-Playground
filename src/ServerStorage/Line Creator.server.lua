local jointA, jointB, line = workspace.JointA , workspace.JointB, Instance.new("Part") 
line.Name = 'METAL LINE'
line.Material = Enum.Material.DiamondPlate
line.Anchored = true

local lineLength = 0.75
line.Color = Color3.fromRGB(99, 95, 98)
line.Size = Vector3.new(lineLength, lineLength, (jointA.Position - jointB.Position).magnitude)
line.CFrame = CFrame.new(jointA.Position + (jointB.Position - jointA.Position) / 2, jointB.Position)
line.Parent = workspace

local group = Instance.new('Model')
local endA, endB = jointA:Clone(), jointB:Clone()
endA.Name = 'LineEnd'
endB.Name = 'LineEnd'
endA.Parent = group
endB.Parent = group
line.Parent = group

local lineNum = 1
for i = 1, #workspace:GetChildren() do
	if workspace:GetChildren()[i].Name:find('Line') then
		lineNum += 1
	end
end

group.Name = 'Line' .. lineNum
group.Parent = workspace