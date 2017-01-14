class 'FirstPerson'

function FirstPerson:__init()
	self.enabled = false -- Set to true to enable fp on join
	self.angle = false -- Set to true to enable fpa on join
	self.invis = false -- Set to true to enable invis on join
	self.activationkey = string.byte("5") -- Set key to toggle fp view
	
	AirhawkEagleHawkChippewa = {[59] = true, [14] = true, [67] = true, [62] = true}
	Pell = {[81] = true}
	Leopard = {[30] = true}
	Cassius = {[51] = true}
	G9 = {[34] = true}
	Bering = {[85] = true}
	Aeroliner = {[39] = true}
	QuapawK22 = {[65] = true, [3] = true}
	Topachula = {[64] = true}
	Sivrkin = {[57] = true}

	Events:Subscribe( "CalcView", self, self.CalcView )
	Events:Subscribe( "KeyUp", self, self.KeyUp )
	Events:Subscribe( "LocalPlayerChat", self, self.LocalPlayerChat )
	Events:Subscribe( "LocalPlayerDeath", self, self.ResetOnDeath )
	Events:Subscribe( "LocalPlayerEnterVehicle", self, self.EnterVehicle )
	Events:Subscribe( "LocalPlayerExitVehicle", self, self.ExitVehicle )

end

function FirstPerson:CalcView()
	if not self.enabled then return end

	if LocalPlayer:GetModelId() == 20 and LocalPlayer:GetVehicle() == nil then
		Network:Send("NotInvis")
	end

	local position = LocalPlayer:GetBonePosition( "ragdoll_Head" )

	if not LocalPlayer:InVehicle() then
		position = position + (Camera:GetAngle() * Vector3( 0, 0.25, 0.2 ))
	else
		local vehicle = LocalPlayer:GetVehicle()
		if AirhawkEagleHawkChippewa[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 0, -0.1, 0.2 ))
		elseif Pell[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 0, -0.1, 0.2 ))
		elseif Leopard[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 0.05, -0.2, 0.3 ))
		elseif Cassius[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 0.3, 0.1, 0.05 ))
		elseif G9[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 0, -0.1, 0.2 ))
		elseif Aeroliner[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 0.4, -0.2, -3.2 ))
		elseif Bering[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 2, 2.5, -5 ))
		elseif QuapawK22[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 0.2, 0.1, 0.3 ))
		elseif Topachula[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 0.0625, -0.1, 0.3 ))
		elseif Sivrkin[vehicle:GetModelId()] then
			position = position + (vehicle:GetAngle() * Vector3( 0, -0.15, 0.3 ))
		else
			position = position + (vehicle:GetAngle() * Vector3( 0, -0.1, 0.2 ))
		end
	end
	Camera:SetPosition( position )
	Camera:SetFOV(0.78539818525314)
	
	if self.angle then
		local angle = LocalPlayer:GetBoneAngle("ragdoll_Head")
		Camera:SetAngle(angle)
	end
	
end

function FirstPerson:KeyUp(args)
	if args.key == self.activationkey then
		self.enabled = not self.enabled
		if self.enabled then
			LocalPlayer:SetValue("fp", true)
		else
			LocalPlayer:SetValue("fp", false)
		end
	end
end

function FirstPerson:LocalPlayerChat(args)
	if args.text == "/fp" then
		self.enabled = not self.enabled
		return false
	elseif args.text == "/fpa" then
		self.angle = not self.angle
		return false
	elseif args.text == "/fparms" then
		self.invis = not self.invis
		if LocalPlayer:InVehicle() then
			if self.invis then
				Network:Send("Invis")
			else
				Network:Send("NotInvis")
			end
		end
		return false
	end	
end

function FirstPerson:EnterVehicle()
	if self.invis then
		Network:Send("Invis")
	end
end

function FirstPerson:ExitVehicle()
	if LocalPlayer:GetModelId() == 20 then
		Network:Send("NotInvis")
	end
end

function FirstPerson:ResetOnDeath()
	self.enabled = false
	Network:Send("NotInvis")
end

firstperson = FirstPerson()