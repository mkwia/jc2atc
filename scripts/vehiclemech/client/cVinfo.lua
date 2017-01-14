class "vinfo"

enabled = false

function vinfo:__init()
	Events:Subscribe("Render", self, self.Render)
	Events:Subscribe("LocalPlayerChat", self, self.chat)
end

function vinfo:chat(args)
	if args.text == "/vinfo" and not enabled then
		Chat:Print("On.", Color.Orange)
		enabled = true
		return false
	elseif args.text == "/vinfo" and enabled then
		Chat:Print("Off.", Color.Orange)
		enabled = false
		return false
	else
		return true
	end
end

function vinfo:Render()
	if enabled and LocalPlayer:InVehicle() then
		Render:DrawText(Vector2(Render.Size.x * 0.8, Render.Size.y * 0.44), "Vehicle Name: "..LocalPlayer:GetVehicle():GetName(), Color.White)
		Render:DrawText(Vector2(Render.Size.x * 0.8, Render.Size.y * 0.47), "Vehicle: "..LocalPlayer:GetVehicle():GetId(), Color.White)
		Render:DrawText(Vector2(Render.Size.x * 0.8, Render.Size.y * 0.50), "ModelID: "..LocalPlayer:GetVehicle():GetModelId(), Color.White)
		Render:DrawText(Vector2(Render.Size.x * 0.8, Render.Size.y * 0.53), "Vehicle Mass: "..math.round(LocalPlayer:GetVehicle():GetMass()), Color.White)
		Render:DrawText(Vector2(Render.Size.x * 0.8, Render.Size.y * 0.56), "Velocity(X: "..math.round(LocalPlayer:GetVehicle():GetLinearVelocity().x)..", Y: "..math.round(LocalPlayer:GetVehicle():GetLinearVelocity().y)..", Z: "..math.round(LocalPlayer:GetVehicle():GetLinearVelocity().z)..", Speed: "..math.round(LocalPlayer:GetVehicle():GetLinearVelocity():Length())..")", Color.White)
		Render:DrawText(Vector2(Render.Size.x * 0.8, Render.Size.y * 0.59), "Angle(X: "..math.round(math.deg(LocalPlayer:GetVehicle():GetAngle().x))..", Y: "..math.round(math.deg(LocalPlayer:GetVehicle():GetAngle().y))..", Z: "..math.round(math.deg(LocalPlayer:GetVehicle():GetAngle().z))..")", Color.White)
		Render:DrawText(Vector2(Render.Size.x * 0.8, Render.Size.y * 0.62), "Angle(Pitch: "..math.round(math.deg(LocalPlayer:GetVehicle():GetAngle().pitch))..", Yaw: "..math.round(math.deg(LocalPlayer:GetVehicle():GetAngle().yaw))..", Roll: "..math.round(math.deg(LocalPlayer:GetVehicle():GetAngle().roll))..")", Color.White)
		Render:DrawText(Vector2(Render.Size.x * 0.8, Render.Size.y * 0.65), "Angular Velocity(X: "..math.round((Angle.Inverse(LocalPlayer:GetVehicle():GetAngle())*LocalPlayer:GetVehicle():GetAngularVelocity()).x)..", Y: "..math.round((Angle.Inverse(LocalPlayer:GetVehicle():GetAngle())*LocalPlayer:GetVehicle():GetAngularVelocity()).y)..", Z: "..math.round((Angle.Inverse(LocalPlayer:GetVehicle():GetAngle())*LocalPlayer:GetVehicle():GetAngularVelocity()).z)..")", Color.White)
	end
end

function math.round(number, decimals)
	local multiply = 10 ^ (decimals or 0)
	return math.floor(number * multiply + 0.5) / multiply
end

vinfo = vinfo()