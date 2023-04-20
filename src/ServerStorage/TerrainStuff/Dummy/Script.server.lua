for _,v in pairs(script.Parent:GetChildren()) do
	if v:isA("BasePart") then
		game.PhysicsService:SetPartCollisionGroup(v, 'Player')
	end
end