class "FiniteFuelVehicle"

function FiniteFuelVehicle:__init(vehicle, fuel)
	self.vehicle = vehicle
	self.vehicleGasType = self:VehicleGasType()
	
	self.fuel = fuel
	self.tankSize = self:TankSize()

	local x = nil
	
	if self.fuel == nil then x = math.random(100) end
	if x ~= nil then
		if x >= 75 then self.fuel = math.random(self.tankSize / 2, self.tankSize) end
		if x < 75 then self.fuel = math.random(self.tankSize / 8, self.tankSize / 2) end
	end
	if self.fuel == "buy" then self.fuel = self.tankSize end
	
	local drainage = self:DrainRate(vehicle)
	local vehicleMass = self.vehicle:GetMass()
	self.drainRate = self.tankSize * 2 * drainage.accelerate
	self.idleDrainRate = self.tankSize * 2 * drainage.idle
end

function FiniteFuelVehicle:VehicleGasType()
	if not IsValid(self.vehicle) then return FiniteFuelGasTypes.Car end
	
	local vehicleGasType = FiniteFuelVehicles[self.vehicle:GetModelId()]
	if vehicleGasType == nil then return FiniteFuelGasTypes.Car else return vehicleGasType end
end

function FiniteFuelVehicle:DrainRate()
	if not IsValid(self.vehicle) then return 1 end
	
	local drainage = FiniteFuelDrainageFormulas[self.vehicleGasType]
	if drainage == nil then return {idle = 0, accelerate = 0}
	else return drainage end
end

function FiniteFuelVehicle:TankSize()
	if not IsValid(self.vehicle) then return 0 end
	
	return tonumber(Vehicle.GetMassByModelId(self.vehicle:GetModelId())) / tonumber(FiniteFuelTankSizeFormulas[self.vehicleGasType])
end