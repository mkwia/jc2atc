ply = nil

Network:Subscribe("BitchSlap", function()

	ply = LocalPlayer

	ply:SetLinearVelocity(Vector3(2, 2, 2))

end)

Events:Subscribe("Render", function()

	if not IsValid(ply) then return end

	ply:SetLinearVelocity(Vector3(1.01, 1.01, 1.01) * ply:GetLinearVelocity():Length())

end)