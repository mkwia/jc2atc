-- math.round function
function math.round(number, decimals)
	local multiply = 10 ^ (decimals or 0)
	return math.floor(number * multiply + 0.5) / multiply
end

class "FiniteFuel"

function FiniteFuel:__init()
	-- Configurable
	self.gasStationMinimapIcon = true -- Square on the minimap showing closest fuel station
	self.gasStationMinimapColor = Color(0, 255, 0) -- The color of the minimap square
	
	self.gasStationMarker = true -- 3D markers that show up at the gas station itself
	self.gasStationMarkerVisibleRadius = 100 -- The radius in which the 3D marker will be visible
	self.gasStationMarkerColor = Color(0, 255, 0, 100) -- The color of the 3D marker
	
	self.gasStationRefuelRadius = 10 -- The radius from the center of the gas station that you can refuel within
	self.gasStationRefuelMaxVelocity = 0.8 -- The maximum velocity you can have while refueling
	
	self.externalRefuel = false -- Set this to true if you want to control refuel with an external script
	self.refuelRate = 7 -- The amount of fuel to refuel every 100 milliseconds, if at a gas station, and externalRefuel = false
	
	self.enterVehicleFuelMessage = false -- Show message with current vehicle's fuel when entering one
	self.enterVehicleMessageColor = Color(255, 0, 0)

	self.repaircost = true -- Whether repairing your vehicle costs money
	self.repairfactor = 5000 -- Multiplying factor to calculate cost

	-- Variables
	self.currentVehicle = nil
	
	self.tickTimer = Timer()
	self.tickTimeout = 100

	self.siphonTimer = Timer()
	self.siphonTimeout = 100

	self.wayTimer = Timer()
	self.wayTime = 5
	--self.wayOn = false
	self.fuelwarn = true
	self.warned = true

	self.full = false

	-- Repair Box
	self.repairbox = Window.Create()
	self.repairbox:SetTitle("Repair Vehicle")
	self.repairbox:SetPositionRel(Vector2(0.7, 0.1))
	self.repairbox:SetSizeRel(Vector2(0.2, 0.1))
	self.repairbox:SetVisible(false)
	self.repairbutton = Button.Create()
	self.repairbutton:SetText("Repair")
	self.repairbutton:SetPositionRel(Vector2(0.0005, 0.005))
	self.repairbutton:SetSizeRel(Vector2(0.19, 0.05))
	self.repairbutton:SetParent(self.repairbox)
	self.repairbutton:Subscribe("Press", self, self.RepairVehicle)
	
	-- Fuel meter
	self.fuelMeterPosition = "TopCenter" -- Options: BottomLeft, BottomRight, BottomCenter, TopRight, TopCenter
	self.fuelMeterRelativeWidth = 0.2 -- value * screen width
	self.fuelMeterRelativeHeight = 0.035 -- value * screen height
	self.fuelMeterBackground = Color(110, 110, 110, 100)
	self.fuelMeterForeground = Color(0, 255, 0)
	self.fuelMeterRelativeTextSize = 0.02 -- value * screen height
	self.fuelMeterTextColor = Color(255, 255, 255)
	
	self.fuelMeterWidth = 0
	self.fuelMeterHeight = 0
	self.fuelMeterLeft = 0
	self.fuelMeterTop = 0
	self.fuelMeterTextLeft = 0
	self.fuelMeterTextTop = 0
	self.fuelMeterIndicatorWidth = 0
	self.fuelMeterTextSize = 0
	self.fuelMeterText = "Fuel"
	
	self.gasStationClosest = {gasStation = nil, distance = nil}
	self.sentAtGasStation = nil

	self.warning = false
	
	self:CalculateMeterPosition({size = Vector2(Render.Width, Render.Height)})
	
	-- Events
	Events:Subscribe("LocalPlayerEnterVehicle", self, self.LocalPlayerEnterVehicle)
	Events:Subscribe("LocalPlayerExitVehicle", self, self.LocalPlayerExitVehicle)
	Events:Subscribe("LocalPlayerInput", self, self.LocalPlayerInput)
	Events:Subscribe("KeyUp", self, self.Siphoning)
	Events:Subscribe("InputPoll", self, self.InputPoll)
	Events:Subscribe("PostTick", self, self.PostTick)
	Events:Subscribe("ResolutionChange", self, self.CalculateMeterPosition)
	Events:Subscribe("Render", self, self.Render)
	Events:Subscribe("LocalPlayerChat", self, self.LocalPlayerChat)
	Events:Subscribe("PostTick", self, self.GetFuelSiphonDrain)
	Events:Subscribe("EntityDespawn", self, self.Despawn)
	
	-- Custom events
	Events:Subscribe("FiniteFuelGetFuel", self, self.LocalGetFuel)
	Events:Subscribe("FiniteFuelSetFuel", self, self.LocalSetFuel)
	
	-- Networked events
	Network:Subscribe("FiniteFuelGetFuel", self, self.GetFuel)
	Network:Subscribe("FiniteFuelReturnFuelSiphon", self, self.GetFuelSiphon)
	
	-- Get current vehicle's fuel if player in one
	if LocalPlayer:InVehicle() and IsValid(LocalPlayer:GetVehicle()) then
		Network:Send("FiniteFuelGetFuel", LocalPlayer:GetVehicle())
	end
end

-- ======================== Position calculations ========================
function FiniteFuel:CalculateMeterPosition(args)
	local size = args.size

	-- Calculate width and height
	self.fuelMeterWidth = size.x * self.fuelMeterRelativeWidth
	self.fuelMeterHeight = size.y * self.fuelMeterRelativeHeight
	
	-- Calculate left and top positions
	self.fuelMeterLeft = 0
	self.fuelMeterTop = 0
	
	if self.fuelMeterPosition == "BottomLeft" then
		self.fuelMeterLeft = 0
		self.fuelMeterTop = size.y - self.fuelMeterHeight
	elseif self.fuelMeterPosition == "BottomRight" then
		self.fuelMeterLeft = size.x - self.fuelMeterWidth
		self.fuelMeterTop = size.y - self.fuelMeterHeight
	elseif self.fuelMeterPosition == "BottomCenter" then
		self.fuelMeterLeft = (size.x / 2) - (self.fuelMeterWidth / 2)
		self.fuelMeterTop = size.y - self.fuelMeterHeight
	elseif self.fuelMeterPosition == "TopRight" then
		self.fuelMeterLeft = size.x - self.fuelMeterWidth
		self.fuelMeterTop = 0
	elseif self.fuelMeterPosition == "TopCenter" then
		self.fuelMeterLeft = (size.x / 2) - (self.fuelMeterWidth / 2)
		self.fuelMeterTop = 0
	end
	
	self.fuelMeterTextSize = size.y * self.fuelMeterRelativeTextSize
	
	self:CalculateTextPosition()
end

function FiniteFuel:CalculateTextPosition()
	if self.currentVehicle == nil or not IsValid(self.currentVehicle.vehicle) or not LocalPlayer:InVehicle() or Game:GetState() ~= GUIState.Game then return end

	local textSize = Render:GetTextSize(math.round(self.currentVehicle.fuel).." / "..math.round(self.currentVehicle.tankSize, self.fuelMeterTextSize))
	
	self.fuelMeterTextLeft = self.fuelMeterLeft + (self.fuelMeterWidth / 2) - (textSize.x / 2)
	self.fuelMeterTextTop = self.fuelMeterTop + (self.fuelMeterHeight / 2) - (textSize.y / 2)

	local textSizecapacity = Render:GetTextSize(math.round(self.currentVehicle.fuel).." / "..math.round(self.currentVehicle.tankSize), self.fuelMeterTextSize)

	self.fuelMetercapacityTextLeft = self.fuelMeterLeft + (self.fuelMeterWidth / 2) - (textSizecapacity.x / 2)
	self.fuelMetercapacityTextTop = self.fuelMeterTop + (self.fuelMeterHeight / 2) - (textSizecapacity.y / 2)
end

-- ======================== Rendering ========================
function FiniteFuel:Render(args)

	--Render Vehicle info (Siphoning)
	if self.siphon then
		if vehicle1 ~= nil then
			if vehicle1.entity == nil then return end
			if vehicle1.entity.__type ~= "Vehicle" then return end
			v1pos = vehicle1.vehicle:GetPosition()
			Render:FillTriangle((v1pos + Vector3(0, 2, 0)), (v1pos + Vector3(-1, 4, 0)), (v1pos + Vector3(1, 4, 0)), Color(255, 0, 0, 200))
			Render:FillTriangle((v1pos + Vector3(0, 2, 0)), (v1pos + Vector3(0, 4, -1)), (v1pos + Vector3(0, 4, 1)), Color(255, 0, 0, 200))
		end
		if vehicle2 ~= nil then
			if vehicle2.entity == nil then return end
			if vehicle2.entity.__type ~= "Vehicle" then return end
			v2pos = vehicle2.vehicle:GetPosition()
			Render:FillTriangle((v2pos + Vector3(0, 2, 0)), (v2pos + Vector3(-1, 4, 0)), (v2pos + Vector3(1, 4, 0)), Color(0, 240, 15, 200))
			Render:FillTriangle((v2pos + Vector3(0, 2, 0)), (v2pos + Vector3(0, 4, -1)), (v2pos + Vector3(0, 4, 1)), Color(0, 240, 15, 200))
		end
	end
	if self.siphoning and vehicle1 ~= nil and vehicle2 ~= nil then
		if vehicle1.fuel < 0 then
			local V1TextLength = Render:GetTextSize("0/"..math.round(vehicle1.tankSize), 0.01)
			local angle = Angle(math.pi + Camera:GetAngle().yaw, 0, math.pi)-- * Angle(math.pi, 0, 0)
			local t1 = Transform3()
			t1:Translate(Vector3(0, 2, 0) + vehicle1.vehicle:GetPosition())
			t1:Rotate(angle)
			t1:Translate(-Vector3(V1TextLength.x, 0, 0)/3)
			Render:SetTransform(t1)
			Render:DrawText(Vector3(0, 0, 0), "0/"..math.round(vehicle1.tankSize), Color.Cyan, 100, 0.01)
		else
			local V1TextLength = Render:GetTextSize(math.round(vehicle1.fuel).."/"..math.round(vehicle1.tankSize), 0.01)
			local angle = Angle(math.pi + Camera:GetAngle().yaw, 0, math.pi)-- * Angle(math.pi, 0, 0)
			local t1 = Transform3()
			t1:Translate(Vector3(0, 2, 0) + vehicle1.vehicle:GetPosition())
			t1:Rotate(angle)
			t1:Translate(-Vector3(V1TextLength.x, 0, 0)/3)
			Render:SetTransform(t1)
			Render:DrawText(Vector3(0, 0, 0), math.round(vehicle1.fuel).."/"..math.round(vehicle1.tankSize), Color.Cyan, 100, 0.01)
		end
		--
		if vehicle2.fuel > vehicle2.tankSize then
			local V2TextLength = Render:GetTextSize(math.round(vehicle2.tankSize).."/"..math.round(vehicle2.tankSize), 0.01)
			local angle = Angle(math.pi + Camera:GetAngle().yaw, 0, math.pi)-- * Angle(math.pi, 0, 0)
			local t2 = Transform3()
			t2:Translate(Vector3(0, 2, 0) + vehicle2.vehicle:GetPosition())
			t2:Rotate(angle)
			t2:Translate(-Vector3(V2TextLength.x, 0, 0)/3)
			Render:SetTransform(t2)
			Render:DrawText(Vector3(0, 0, 0), math.round(vehicle2.tankSize).."/"..math.round(vehicle2.tankSize), Color.Cyan, 100, 0.01)
		else
			local V2TextLength = Render:GetTextSize(math.round(vehicle2.fuel).."/"..math.round(vehicle2.tankSize), 0.01)
			local angle = Angle(math.pi + Camera:GetAngle().yaw, 0, math.pi)-- * Angle(math.pi, 0, 0)
			local t2 = Transform3()
			t2:Translate(Vector3(0, 2, 0) + vehicle2.vehicle:GetPosition())
			t2:Rotate(angle)
			t2:Translate(-Vector3(V2TextLength.x, 0, 0)/3)
			Render:SetTransform(t2)
			Render:DrawText(Vector3(0, 0, 0), math.round(vehicle2.fuel).."/"..math.round(vehicle2.tankSize), Color.Cyan, 100, 0.01)
		end
	end

	if self.currentVehicle == nil or not IsValid(self.currentVehicle.vehicle) or not LocalPlayer:InVehicle() or Game:GetState() ~= GUIState.Game then return end
	
	-- Draw background
	Render:FillArea(Vector2(self.fuelMeterLeft, self.fuelMeterTop), Vector2(self.fuelMeterWidth, self.fuelMeterHeight), self.fuelMeterBackground)
	--Render:FillArea(Vector2(self.fuelMeterLeft - 2, self.fuelMeterTop), Vector2(2, self.fuelMeterHeight + 2), Color(0, 0, 0, 200))
	--Render:FillArea(Vector2(self.fuelMeterLeft - 2, self.fuelMeterTop + self.fuelMeterHeight), Vector2(self.fuelMeterWidth + 4, 2), Color(0, 0, 0, 200))
	--Render:FillArea(Vector2(self.fuelMeterLeft + self.fuelMeterWidth, self.fuelMeterTop), Vector2(2, self.fuelMeterHeight + 2), Color(0, 0, 0, 200))
	
	-- Draw indicator
	Render:FillArea(Vector2(self.fuelMeterLeft, self.fuelMeterTop), Vector2(self.fuelMeterIndicatorWidth, self.fuelMeterHeight), self.fuelMeterForeground)
	--Render:FillArea(Vector2(self.fuelMeterLeft - 1.5 + self.fuelMeterWidth * 1/8, self.fuelMeterTop + self.fuelMeterHeight * 3/4), Vector2(3, self.fuelMeterHeight / 4), Color.Red)
	Render:FillArea(Vector2(self.fuelMeterLeft - 1.5 + self.fuelMeterWidth * 1/4, self.fuelMeterTop + self.fuelMeterHeight / 2), Vector2(3, self.fuelMeterHeight / 2), Color.Red)
	--Render:FillArea(Vector2(self.fuelMeterLeft - 1.5 + self.fuelMeterWidth * 3/8, self.fuelMeterTop + self.fuelMeterHeight * 3/4), Vector2(3, self.fuelMeterHeight / 4), Color.Red)
	Render:FillArea(Vector2(self.fuelMeterLeft - 1.5 + self.fuelMeterWidth * 1/2, self.fuelMeterTop + self.fuelMeterHeight * 3/4), Vector2(3, self.fuelMeterHeight / 4), Color.Red)
	--Render:FillArea(Vector2(self.fuelMeterLeft - 1.5 + self.fuelMeterWidth * 5/8, self.fuelMeterTop + self.fuelMeterHeight * 3/4), Vector2(3, self.fuelMeterHeight / 4), Color.Red)
	Render:FillArea(Vector2(self.fuelMeterLeft - 1.5 + self.fuelMeterWidth * 3/4, self.fuelMeterTop + self.fuelMeterHeight / 2), Vector2(3, self.fuelMeterHeight / 2), Color.Red)
	--Render:FillArea(Vector2(self.fuelMeterLeft - 1.5 + self.fuelMeterWidth * 7/8, self.fuelMeterTop + self.fuelMeterHeight * 3/4), Vector2(3, self.fuelMeterHeight / 4), Color.Red)

	-- Draw text
	Render:DrawText(Vector2(self.fuelMeterLeft + self.fuelMeterWidth + 5, self.fuelMeterTop + 5), self.fuelMeterText, self.fuelMeterTextColor, self.fuelMeterTextSize * 0.9)
	if self.fuelMetercapacityTextLeft ~= nil and self.fuelMetercapacityTextTop ~= nil then
		Render:DrawText(Vector2(self.fuelMetercapacityTextLeft, self.fuelMetercapacityTextTop), math.round(self.currentVehicle.fuel).." / "..math.round(self.currentVehicle.tankSize), self.fuelMeterTextColor, self.fuelMeterTextSize)
	end

	-- Draw closest gas station on minimap
	if self.gasStationMinimapIcon and self.gasStationClosest.gasStation ~= nil then
		--local transform = Transform2()
		--transform:Translate(Vector2(0, 0))
		--transform:Rotate(math.pi / 4)
		--Render:SetTransform(transform)
		Render:FillCircle(Render:WorldToMinimap(self.gasStationClosest.gasStation.position), 5, self.gasStationMinimapColor)
		Render:DrawCircle(Render:WorldToMinimap(self.gasStationClosest.gasStation.position), 5, Color(0, 0, 0))
	end
	
	-- Draw gas station marker
	if self.gasStationMarker and self.gasStationClosest.gasStation ~= nil and self.gasStationClosest.distance <= self.gasStationMarkerVisibleRadius then
		local position = self.gasStationClosest.gasStation.position
		local distance = self.gasStationClosest.distance
		local pos1 = position
		local pos2 = position + (Vector3(-1, 2, 0) * (distance / 20))
		local pos3 = position + (Vector3(1, 2, 0) * (distance / 20))
		Render:FillTriangle(pos1, pos2, pos3, self.gasStationMarkerColor)
		pos1 = position
		pos2 = position + (Vector3(0, 2, -1) * (distance / 20))
		pos3 = position + (Vector3(0, 2, 1) * (distance / 20))
		Render:FillTriangle(pos1, pos2, pos3, self.gasStationMarkerColor)
	end

	--Render a warning
	if self.warning then
		if self.vehicleGasType == FiniteFuelGasTypes.Aircraft then
		Render:DrawText(Vector2(Render.Size.x * 0.5 - (Render:GetTextSize("LOW FUEL", 40 * Render.Size.x / 1000).x / 2), Render.Size.y * 0.25), "LOW FUEL", Color.Red, 40 * Render.Size.x / 1000)
		end
		if LocalPlayer:GetValue("nofuel") ~= true then
			LocalPlayer:SetValue("nofuel", true)
		end
	end
	if LocalPlayer:GetValue("nofuel") ~= false and not self.warning then
		LocalPlayer:SetValue("nofuel", false)
	end
end

-- ======================== Enter/exit vehicle ========================
function FiniteFuel:LocalPlayerEnterVehicle(args)
	if not IsValid(args.vehicle) then return end
	
	self.gasStationClosest = {gasStation = nil, distance = nil}
	
	Network:Send("FiniteFuelGetFuel", args.vehicle)
end

function FiniteFuel:LocalPlayerExitVehicle(args)	
	if self.currentVehicle == nil or self.currentVehicle.vehicle ~= args.vehicle then return end
	
	Network:Send("FiniteFuelSetFuel", {vehicle = args.vehicle, fuel = self.currentVehicle.fuel})
	
	-- Notify external scripts of fuel station exit
	if self.externalRefuel and self.sentAtGasStation ~= nil then
		Events:Fire("FiniteFuelExitedGasStation", {vehicle = self.currentVehicle.vehicle, gasStation = self.sentAtGasStation})
		self.sentAtGasStation = nil
	end
	
	self.currentVehicle = nil

	if not self.fuelwarn then
		Waypoint:Remove()
		self.fuelwarn = true
	end

	if self.repairbox:GetVisible() then
		self.repairbox:SetVisible(false)
		Mouse:SetVisible(false)
	end
end

-- ======================== Tick update events ========================
function FiniteFuel:InputPoll()
	if self.currentVehicle == nil or
	not IsValid(self.currentVehicle.vehicle) or
	self.currentVehicle.fuel > 0 or
	(self.currentVehicle.vehicleGasType ~= FiniteFuelGasTypes.Aircraft and self.currentVehicle.vehicleGasType ~= FiniteFuelGasTypes.Aircraft) then return end
	
	Input:SetValue(Action.HeliDecAltitude, 1)
	Input:SetValue(Action.PlaneDecTrust, 1)
	Input:SetValue(Action.HeliIncAltitude, 0)
	Input:SetValue(Action.PlaneIncTrust, 0)
end

function FiniteFuel:PostTick()
	if self.tickTimer:GetMilliseconds() < self.tickTimeout or self.currentVehicle == nil or not IsValid(self.currentVehicle.vehicle) then return end
	self.tickTimer:Restart()
	
	local playerPosition = LocalPlayer:GetPosition()
	if self.gasStationClosest.gasStation ~= nil then self.gasStationClosest.distance = Vector3.Distance(self.gasStationClosest.gasStation.position, playerPosition) end
	for index, gasStation in ipairs(FiniteFuelGasStations) do
		-- Only evaluate if of same gas type
		if gasStation.gasType == self.currentVehicle.vehicleGasType then
			local gasStationPosition = gasStation.position
			local distance = Vector3.Distance(gasStationPosition, playerPosition)
			
			-- Closer than last gas station checked
			if self.gasStationClosest.distance == nil or distance < self.gasStationClosest.distance then
				self.gasStationClosest = {gasStation = gasStation, distance = distance}
			end
		end
	end
	
	-- Close and moving slow enough to refuel, and tank is not full
	local velocity = self.currentVehicle.vehicle:GetLinearVelocity():Length()
	local idling = velocity <= self.gasStationRefuelMaxVelocity

	-- Initiate repair section
	if self.currentVehicle.vehicle:GetHealth() < 1 and self.gasStationClosest.distance ~= nil and self.gasStationClosest.distance <= self.gasStationRefuelRadius and idling then
		if not self.repairbox:GetVisible() and LocalPlayer:GetVehicle():GetDriver() == LocalPlayer then
			self.repairbox:SetVisible(true)
			Mouse:SetVisible(true)
		end
		if self.repaircost then
			local vehicle = self.currentVehicle.vehicle
			local repairamount = 1 - vehicle:GetHealth()
			local repaircost = math.floor(repairamount * self.repairfactor)
			self.repairbutton:SetText("Repair - $"..repaircost)
		end
	elseif self.repairbox:GetVisible() then
		self.repairbox:SetVisible(false)
		Mouse:SetVisible(false)
	end
	
	if self.gasStationClosest.distance ~= nil and self.gasStationClosest.distance <= self.gasStationRefuelRadius and idling and self.currentVehicle.fuel < self.currentVehicle.tankSize then
		local pos,boolean = Waypoint:GetPosition()
		if not self.fuelwarn and boolean then
			Waypoint:Remove()
			self.fuelwarn = false
		end
		if not self.externalRefuel then
			-- Fuel up. Set to tank size if full
			if self.currentVehicle.vehicle:GetModelId() == 85 or
			self.currentVehicle.vehicle:GetModelId() == 39 or
			self.currentVehicle.vehicle:GetModelId() == 50 then
				self.currentVehicle.fuel = self.currentVehicle.fuel + 28
			else
				self.currentVehicle.fuel = self.currentVehicle.fuel + self.refuelRate
			end
			if self.currentVehicle.fuel > self.currentVehicle.tankSize then
				self.currentVehicle.fuel = self.currentVehicle.tankSize
				self.full = true
			end
			
			-- Change text
			if self.fuelMeterText ~= "Refuelling..." and not self.full then
				self.fuelMeterText = "Refuelling..."
				self:CalculateTextPosition()
			end
			if self.fuelMeterText ~= "Full" and self.full then
				self.fuelMeterText = "Full"
				self:CalculateTextPosition()
			end
		else
			-- Send network event for external refuelling scripts
			if self.sentAtGasStation ~= self.gasStationClosest.gasStation then
				self.sentAtGasStation = self.gasStationClosest.gasStation
				Events:Fire("FiniteFuelEnteredGasStation", {vehicle = self.currentVehicle.vehicle, vehicleGasType = self.currentVehicle.vehicleGasType, gasStation = self.gasStationClosest.gasStation})
			end
		end
	elseif idling and self.currentVehicle.fuel > 0 then -- Idling
		-- Drain idle. Set tank to 0 if less than empty
		self.currentVehicle.fuel = self.currentVehicle.fuel - self.currentVehicle.idleDrainRate
		
		-- Change text
		if self.fuelMeterText ~= "Idle" and not self.full then
			self.fuelMeterText = "Idle"
			self:CalculateTextPosition()
		end
		if self.currentVehicle.fuel < 0 then self.currentVehicle.fuel = 0 end
	elseif not idling and self.currentVehicle.fuel > 0 then -- Moving
		-- Drain moving. Set tank to 0 if less than empty
		local drain = (velocity * self.currentVehicle.drainRate)-- * 100 -- DEBUGGING
		self.currentVehicle.fuel = self.currentVehicle.fuel - drain
		if self.currentVehicle.fuel < 0 then self.currentVehicle.fuel = 0 end
		
		-- Change text
		if self.fuelMeterText ~= "Fuel" then
			self.fuelMeterText = "Fuel"
			self:CalculateTextPosition()
		end
	end
	
	if self.currentVehicle.fuel < self.currentVehicle.tankSize * 199/200 then
		self.full = false
	end

	-- Send left gas station to external scripts
	if self.externalRefuel and self.sentAtGasStation ~= nil and self.gasStationClosest.distance > self.gasStationRefuelRadius then
		Events:Fire("FiniteFuelExitedGasStation", {vehicle = self.currentVehicle.vehicle, gasStation = self.sentAtGasStation})
		self.sentAtGasStation = nil
	end

	-- Set "fuelwarn"
	if self.currentVehicle.fuel > (self.currentVehicle.tankSize / 4) and not self.fuelwarn then
		self.fuelwarn = true
		self.warned = true
	end

	-- Check whether to set waypoint when fuel is at 1/4
	if self.currentVehicle.fuel < (self.currentVehicle.tankSize / 4) and self.fuelwarn then
		--self.wayOn = true
		--self.wayTimer:Restart()
		--if self.warned then
		--	Chat:Print("You are low on fuel, set waypoint to nearest petrol station?", Color.Cyan)
		--	Chat:Print("Type 'Y' if you want to.", Color.Cyan)
		--	self.warned = false
		--end
		local pos,boolean = Waypoint:GetPosition()
		if self.gasStationClosest.gasStation.position ~= nil and not boolean then
		--if self.waypoint and self.wayTimer:GetSeconds() < self.wayTime and self.gasStationClosest.gasStation.position ~= nil then
			Waypoint:SetPosition(self.gasStationClosest.gasStation.position)
		--	self.waypoint = false
			self.fuelwarn = false
		--elseif not self.waypoint and self.wayTimer:GetSeconds() >= self.wayTime then
		--	self.fuelwarn = false
		end
	end
	
	-- Calculate indicator width
	self.fuelMeterIndicatorWidth = self.fuelMeterWidth / self.currentVehicle.tankSize * self.currentVehicle.fuel
end

function FiniteFuel:RepairVehicle()
	local vehicle = self.currentVehicle.vehicle
	if self.repaircost then
		local repairamount = 1 - vehicle:GetHealth()
		local repaircost = math.floor(repairamount * self.repairfactor)
		args = {}
		args.vehicle = vehicle
		args.cost = repaircost
		args.player = LocalPlayer
		Network:Send("Repair", args)
	else
		args = {}
		args.vehicle = vehicle
		args.cost = nil
		args.player = LocalPlayer
		Network:Send("Repair", args)
	end
end
-- ======================== Movement blocker ========================
function FiniteFuel:LocalPlayerInput(args)
	if self.currentVehicle == nil or not IsValid(self.currentVehicle.vehicle) or self.currentVehicle.fuel > 0 then self.warning = false return end
	
	-- Fuel empty, block movement keys
	self.warning = true
	return not FiniteFuelVehicleKeys[args.input]
end

-- ======================== Fuel Siphoning ======================
function FiniteFuel:LocalPlayerChat(args)
	--if string.lower(args.text) == "y" and self.wayOn and IsValid(self.currentVehicle.vehicle) then
	--	self.wayOn = false
	--	self.waypoint = true
	--	return false
	--end
	local words = string.split(args.text, " ")
	if args.text == "/dump" then
		self.currentVehicle.fuel = 0
	end
	if args.text == "/siphon" and self.siphon ~= true then
		self.siphon = true
		vehicle1 = nil
		vehicle2 = nil
		Chat:Print("Select two vehicles to siphon fuel (Hold F to select).", Color.Cyan)
	elseif args.text == "/siphon" and self.siphon == true then
		Chat:Print("Siphoning disabled.", Color.Cyan)
		self.siphon = false
	end
end

function FiniteFuel:Siphoning(args)
	if self.siphon then
		if vehicle1 == nil then
			if args.key == string.byte("F") then
				vehicle1 = LocalPlayer:GetAimTarget()
				if vehicle1 == nil or
				vehicle1.entity == nil or
				vehicle1.entity.__type ~= "Vehicle" or
				vehicle1.entity:GetDriver() ~= nil then
					Chat:Print("Selection failed.", Color.Red)
					vehicle1 = nil
				else
					Chat:Print("Siphoning from "..vehicle1.entity:GetName()..".", Color.Cyan)
				end
			end
		elseif vehicle1 ~= nil and vehicle2 == nil then
			if args.key == string.byte("F") then
				vehicle2 = LocalPlayer:GetAimTarget()
				if vehicle2 == nil or
				vehicle2.entity == nil or
				vehicle2.entity.__type ~= "Vehicle" or
				vehicle1.entity == vehicle2.entity or
				vehicle2.entity:GetDriver() ~= nil then
					Chat:Print("Selection failed.", Color.Red)
					vehicle2 = nil
				elseif vehicle1.entity:GetPosition():Distance(vehicle2.entity:GetPosition()) > 20 then
					vehicle2 = nil
					Chat:Print("Vehicles too far apart!", Color.Red)
				else
					Chat:Print("Siphoning to "..vehicle2.entity:GetName()..".", Color.Cyan)
					Chat:Print("Press Enter to confirm selection.", Color.Cyan)
					self.siphonconfirm = true
				end
			end
		end
	end
	if self.siphonconfirm then
		if args.key == 13 then
			args = {}
			args.vehicle1 = vehicle1.entity
			args.vehicle2 = vehicle2.entity
			Network:Send("FiniteFuelGetFuelSiphon", args)
			self.siphon = false
			self.siphonenable = false
			self.siphonconfirm = false
			Chat:Print("Press Enter to finish siphoning.", Color.Cyan)
		end
	end
	if self.siphoning then
		if args.key == 13 then
			self.siphoning = false
			self.siphonenable = true
			Chat:Print("Siphoning complete!", Color.Cyan)
			Network:Send("FiniteFuelSetFuel", {vehicle = vehicle1.vehicle, fuel = vehicle1.fuel})
			Network:Send("FiniteFuelSetFuel", {vehicle = vehicle2.vehicle, fuel = vehicle2.fuel})
		end
	end
end

function FiniteFuel:GetFuelSiphon(args)
	vehicle1 = FiniteFuelVehicle(args.vehicle1, args.fuel1)
	vehicle2 = FiniteFuelVehicle(args.vehicle2, args.fuel2)
	self.siphoning = true
end

function FiniteFuel:GetFuelSiphonDrain()
	if self.siphoning then
			Network:Send("RemoveDriver", {vehicle1 = vehicle1.vehicle, vehicle2 = vehicle2.vehicle})
		if self.siphonTimer:GetMilliseconds() >= self.siphonTimeout then
			if vehicle1.fuel > 0 and vehicle2.fuel < vehicle2.tankSize then
				vehicle1.fuel = vehicle1.fuel - 5
				vehicle2.fuel = vehicle2.fuel + 5
				self.siphonTimer:Restart()
			elseif vehicle1.fuel < 0 then
				vehicle1.fuel = 0
			elseif vehicle1.fuel > vehicle1.tankSize then
				vehicle1.fuel = vehicle1.tankSize
			elseif vehicle2.fuel < 0 then
				vehicle2.fuel = 0
			elseif vehicle2.fuel > vehicle2.tankSize then
				vehicle2.fuel = vehicle2.tankSize
			else
				self.siphoning = false
				self.siphonenable = true
				Chat:Print("Siphoning complete!", Color.Cyan)
				Network:Send("FiniteFuelSetFuel", {vehicle = vehicle1.vehicle, fuel = vehicle1.fuel})
				Network:Send("FiniteFuelSetFuel", {vehicle = vehicle2.vehicle, fuel = vehicle2.fuel})
			end
		end
	end
end

-- ======================== Vehicle info ========================
function FiniteFuel:GetFuel(args)
	local vehicle = args.vehicle
	local fuel = args.fuel
	
	self.currentVehicle = FiniteFuelVehicle(vehicle, fuel)
	if self.enterVehicleFuelMessage then
		Chat:Print("Vehicle currently has " .. math.round(self.currentVehicle.fuel) .. "/" .. math.round(self.currentVehicle.tankSize) .. " fuel.", self.enterVehicleMessageColor)
	end
end

-- ======================== Local events ========================
function FiniteFuel:LocalGetFuel()
	if self.currentVehicle == nil or not IsValid(self.currentVehicle.vehicle) then return end
	
	Events:Fire("FiniteFuelReturnGetFuel", {vehicle = self.currentVehicle.vehicle, vehicleGasType = self.currentVehicle.vehicleGasType, fuel = self.currentVehicle.fuel, tankSize = self.currentVehicle.tankSize})
end

function FiniteFuel:LocalSetFuel(fuel)
	if fuel < 0 or self.currentVehicle == nil or not IsValid(self.currentVehicle.vehicle) then return end
	
	if fuel > self.currentVehicle.tankSize or fuel == nil then fuel = self.currentVehicle.tankSize end
	
	self.currentVehicle.fuel = fuel
end

-- ======================== Clean Up ==========================
function FiniteFuel:Despawn(args)
	if args.entity.__type == "Vehicle" then
		if self.siphon and 
		vehicle1 ~= nil and
		vehicle2 ~= nil then
			if args.entity == vehicle1.entity or
			args.entity == vehicle2.entity then
				vehicle1 = nil
				vehicle2 = nil
				self.siphon = false
				Chat:Print("Cancelled due to vehicle despawn.", Color.Red)
			end
		elseif self.siphoning then
			if args.entity == vehicle1.vehicle or
			args.entity == vehicle2.vehicle then
				vehicle1 = nil
				vehicle2 = nil
				self.siphoning = false
				Chat:Print("Cancelled due to vehicle despawn.", Color.Red)
			end
		end
	end
end

-- ======================== Initialize ========================
Events:Subscribe("ModuleLoad", function()
	FiniteFuel()
end)