class 'VTOL'

function VTOL:__init()
	VTOLActive			=	true	--	Whether or not VTOL is active by default.			Default: true
	VTOLKey				=	88		--	The key to activate VTOL, this is Z by default.									Default: 90
	VTOLLandKey			=	162		--	The key to switch VTOL to down instead of up, this is Left Control by default.	Default: 162
	PlaneVehicles		=	{30}	--	Vehicle ID for leopard.
	
	--	Info Text Config	--
	DisplayPosX			=	0.95	--	The Horizontal Position of the info text.	Default: 0.95
	DisplayPosY			=	0.95	--	The Vertical Position of the info text.		Default: 0.95
	TextFontSize		=	14		--	The font size of the info text.				Default: 14
	
	--	Thrust Config	--
	MaxThrust				=	5		--	The maximum thrust speed.						Default: 10
	MinThrust				=	0.1		--	The minimum thrust speed.						Default: 0.1
	CurrentThrust			=	0		--	The starting thrust speed.						Default: 0
	MaxVTOLLandThrust		=	5		--	The maximum VTOL down thrust speed.				Default: 10
	MinVTOLLandThrust		=	0.001	--	The minimum VTOL down thrust speed.				Default: 0.001
	VTOLLandThrust			=	2		--	The starting VTOL down thrust speed.			Default: 2
	MaxReverseThrust		=	1.5		--	The maximum speed a plane can go in reverse.	Default: 1.5
	ThrustIncreaseFactor	=	1.05	--	How quickly thrust is increased.				Default: 1.05
	ThrustDecreaseFactor	=	0.9		--	How quickly thrust is decreased.				Default: 0.9
	VTOLLandThrustFactor	=	0.95	--	how quickly speed is slowed when going into a VTOL Land.	Default: 
	ThrustDecreaseInteger	=	1		--	How quickly, in seconds, the system checks to see if thrust should decrease.	Default: 1
	ThrustDecreaseTimer		=	Timer()
	
	self.Version		=	"3.0"	--	Which version of VTOL this script is. DO NOT CHANGE.
	
	print(tostring(self) .. " " .. tostring(self.Version) .. " loaded.")
	
	Events:Subscribe("MouseScroll", self, self.MouseScroll)
	Events:Subscribe("InputPoll", self, self.ThrustVectoring)
	Events:Subscribe("LocalPlayerChat", self, self.LocalPlayerChat)
	Events:Subscribe("LocalPlayerEnterVehicle", self, self.LocalPlayerEnterVehicle)
	Events:Subscribe("LocalPlayerEjectVehicle", self, self.BlockEject)
	Events:Subscribe("Render", self, self.Render)
	Events:Subscribe("PreTick", self, self.Thrust)
	Events:Subscribe("PostTick", self, self.PostTick)
end

function VTOL:MouseScroll(args)
	if args.delta == 1 then
		VTOLLandThrust	=	VTOLLandThrust + 0.5
	elseif args.delta == -1 then
		VTOLLandThrust	=	VTOLLandThrust - 0.5
	end
	if VTOLLandThrust < MinVTOLLandThrust then
		VTOLLandThrust	=	MinVTOLLandThrust
	elseif VTOLLandThrust > MaxVTOLLandThrust then
		VTOLLandThrust	=	MaxVTOLLandThrust
	end
end

function VTOL:ThrustVectoring(args)

	local vehicle = LocalPlayer:GetVehicle()

	if not vehicle then return end

	local LocalVehicleModel = vehicle:GetModelId()

	if Key:IsDown(VTOLKey) and self:CheckList(PlaneVehicles, LocalVehicleModel) and LocalPlayer:GetValue("nofuel") ~= true then

		if Key:IsDown(string.byte("A")) then
			Input:SetValue(63, 0)
			Input:SetValue(64, 0)
			anglevy = 0.5
		end
		if Key:IsDown(string.byte("D")) then
			Input:SetValue(63, 0)
			Input:SetValue(64, 0)
			anglevy = -0.5
		end
		if Key:IsDown(string.byte("W")) then
			Input:SetValue(63, 0)
			Input:SetValue(64, 0)
			anglevp = -0.5
		end
		if Key:IsDown(string.byte("S")) then
			Input:SetValue(63, 0)
			Input:SetValue(64, 0)
			anglevp = 0.5	
		end
		if Key:IsDown(string.byte("R")) then
			Input:SetValue(63, 0)
			Input:SetValue(64, 0)
			anglevr = 0.5	
		end
		if Key:IsDown(string.byte("F")) then
			Input:SetValue(63, 0)
			Input:SetValue(64, 0)
			anglevr = -0.5	
		end
		if not Key:IsDown(string.byte("W")) and not Key:IsDown(string.byte("S")) then
			Input:SetValue(63, 0)
			Input:SetValue(64, 0)
			anglevp = 0	
		end
		if not Key:IsDown(string.byte("A")) and not Key:IsDown(string.byte("D")) then
			Input:SetValue(63, 0)
			Input:SetValue(64, 0)
			anglevy = 0
		end
		if not Key:IsDown(string.byte("R")) and not Key:IsDown(string.byte("F")) then
			Input:SetValue(63, 0)
			Input:SetValue(64, 0)
			anglevr = 0	
		end
		self:VectorAddition(vehicle)

	end

end

function VTOL:VectorAddition(vehicle)

	local angularvelocity = Vector3(anglevp, anglevy, anglevr)
	vehicle:SetAngularVelocity(vehicle:GetAngle() * angularvelocity)

end

function VTOL:LocalPlayerChat(args)
	local msg	=	string.split(args.text, " ")	--	Split at Spaces.
    if	string.lower(msg[1]) == "/vtol" then
    	Chat:Print("---VTOL Instructions---", Color(0, 240, 10))
    	Chat:Print("This only works in the Si-47 Leopard!", Color.LightGreen)
    	Chat:Print("Hold X to take off.", Color.Silver)
    	Chat:Print("Hold X + Shift to maintain horizontal velocity.", Color.Silver)
    	Chat:Print("Hold X + LCtrl to enter landing mode.", Color.Silver)
    	Chat:Print("When in landing mode, use the mousewheel to change velocity.", Color.Silver)
    	Chat:Print("Use A and D in any VTOL mode to change yaw.", Color.Silver)
    	Chat:Print("Use R and F in any VTOL mode to change roll.", Color.Silver)
    	return false
    end
end

function VTOL:LocalPlayerEnterVehicle()
	CurrentThrust	=	0
	VTOLLandThrust	=	1
end

function VTOL:BlockEject()

	local vehicle = LocalPlayer:GetVehicle()

	if not vehicle then return end

	local LocalVehicleModel = vehicle:GetModelId()

	if Key:IsDown(VTOLKey) and self:CheckList(PlaneVehicles, LocalVehicleModel) and LocalPlayer:GetValue("nofuel") ~= true then

		return false

	end

end

function VTOL:Render()
	if Game:GetState() ~= GUIState.Game then return end
	local ScreenSize			=	Render.Size
	LocalVehicle	=	LocalPlayer:GetVehicle()
	if not LocalVehicle then return end
	if LocalVehicle:GetDriver() ~= LocalPlayer then return end
	LocalVehicleModel	=	LocalVehicle:GetModelId()
	if self:CheckList(PlaneVehicles, LocalVehicleModel) then
		VTOLActive = true
		local Offset = 20
		if VTOLActive then
			self:DrawTextOnScreen(Vector2(ScreenSize.x * DisplayPosX, ScreenSize.y * DisplayPosY + Offset), "/VTOL for instructions.", Color.White, TextFontSize)
			Offset	=	Offset + TextFontSize
		end
	else
		VTOLActive = false
	end
end

function VTOL:CheckThrust()
	if Key:IsDown(VTOLLandKey) then return end
	CurrentThrust	=	CurrentThrust * ThrustIncreaseFactor
	if CurrentThrust < MinThrust then
		CurrentThrust	=	MinThrust
	elseif CurrentThrust > MaxThrust then
		CurrentThrust	=	MaxThrust
	end
	ReverseThrust	=	CurrentThrust
	if ReverseThrust > MaxReverseThrust then
		ReverseThrust = MaxReverseThrust
	end
end

function VTOL:Thrust(args)
	if Game:GetState() ~= GUIState.Game then return end
	LocalVehicle	=	LocalPlayer:GetVehicle()
	if not LocalVehicle then return end
	if LocalVehicle:GetDriver() ~= LocalPlayer then return end
	LocalVehicleModel	=	LocalVehicle:GetModelId()
	if self:CheckList(PlaneVehicles, LocalVehicleModel) and LocalPlayer:GetValue("nofuel") ~= true then
		local VehicleVelocity	=	LocalVehicle:GetLinearVelocity()
		if IsValid(LocalVehicle) then
			if Key:IsDown(VTOLKey) and VTOLActive and not Key:IsDown(160) then
				self:CheckThrust()
				local SetThrust			=	Vector3(0, CurrentThrust, 0)
				if Key:IsDown(VTOLLandKey) then
					SetThrust			=	Vector3(VehicleVelocity.x * VTOLLandThrustFactor, -VTOLLandThrust, VehicleVelocity.z * VTOLLandThrustFactor)
				end
				LocalVehicle:SetLinearVelocity(SetThrust)
			end
			if Key:IsDown(VTOLKey) and VTOLActive and Key:IsDown(160) then
				self:CheckThrust()
				local SetThrust			=	Vector3(VehicleVelocity.x, CurrentThrust, VehicleVelocity.z)
				if Key:IsDown(VTOLLandKey) then
					SetThrust			=	Vector3(VehicleVelocity.x * VTOLLandThrustFactor, -VTOLLandThrust, VehicleVelocity.z * VTOLLandThrustFactor)
				end
				LocalVehicle:SetLinearVelocity(SetThrust)
			end
		end
	end
end

function VTOL:PostTick()
	if Key:IsDown(VTOLKey) then return end
	if ThrustDecreaseTimer:GetSeconds() >= ThrustDecreaseInteger then
		ThrustDecreaseTimer:Restart()
		if CurrentThrust > 0 then
			if CurrentThrust > MaxThrust/2 then
				CurrentThrust	=	CurrentThrust * ThrustDecreaseFactor / 2
			else
				CurrentThrust	=	CurrentThrust * ThrustDecreaseFactor
			end
		end
	end
end

function VTOL:CheckList(tableList, modelID)
	for k,v in pairs(tableList) do
		if v == modelID then return true end
	end
	return false
end

--	Anchored:	1 is left, 2 is right.
function VTOL:DrawTextOnScreen(pos, text, color, fontsize, anchored)
	local ScreenSize			=	Render.Size
	local DisplayText			=	text
	local EffectiveFontSize		=	fontsize * ScreenSize.y / 1000
	local Textsize				=	Render:GetTextSize(DisplayText, EffectiveFontSize)
	local DisplayPosition	=	Vector2(pos.x - Textsize.x / 2, pos.y  - Textsize.y / 2)
	if anchored then
		if anchored == 1 then		--	Left Align
			DisplayPosition		=	Vector2(pos.x, pos.y  - Textsize.y / 2)
		elseif anchored == 2 then	--	Right Align
			DisplayPosition		=	Vector2(pos.x - Textsize.x, pos.y  - Textsize.y / 2)
		end
	end
	
    Render:DrawText(DisplayPosition + Vector2(1, 1), DisplayText, Color(0, 0, 0, 200), EffectiveFontSize)
    Render:DrawText(DisplayPosition, DisplayText, color, EffectiveFontSize)
end

VTOL = VTOL()