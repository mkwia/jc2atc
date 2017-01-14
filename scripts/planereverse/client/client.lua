class 'ReverseThrust'

function ReverseThrust:__init()

	self.planes = {}
	self.planes[24] = true -- F-33 DragonFly
	self.planes[30] = true -- Si-47 Leopard
	self.planes[34] = true -- G9 Eclipse
	self.planes[39] = true -- Aeroliner 474
	self.planes[51] = true -- Cassius 192
	self.planes[59] = true -- Peek Airhawk 225
	self.planes[81] = true -- Pell Silverbolt 6
	self.planes[85] = true -- Bering I-86DP
	
	self.max_reverse_speed = 5
	
	self.stop = {}
	self.stop.delay = 500
	
	self.network = {}
	self.network.delay = 100
	
	self.silly = false
	self.VTOLLand = false
		
	Events:Subscribe("LocalPlayerInput", self, self.ActivateThrust)
	Events:Subscribe("LocalPlayerChat", self, self.SillyThrust)
	Events:Subscribe("KeyDown", self, self.DisableonVTOLLand)
	Events:Subscribe("KeyUp", self, self.EnableonnotVTOLLand)
	Events:Subscribe("LocalPlayerExitVehicle", self, self.RemoveTimers)
	
end

function ReverseThrust:SillyThrust(args)

	if args.text == "/reverse" then
		if not self.silly then
			Chat:Print("Reverse thrust allowed while flying.", Color.Silver)
		elseif self.silly then
			Chat:Print("Reverse thrust disallowed while flying.", Color.Silver)
		end
		self.silly = not self.silly
		return false
	end

end

function ReverseThrust:RemoveTimers()

	if self.stop.timer or self.network.timer then
		self.stop.timer = nil
		self.network.timer = nil
	end
	
end

function ReverseThrust:DisableonVTOLLand(args)
	if args.key == string.byte("X") then
		self.VTOLLand = true
	end
end

function ReverseThrust:EnableonnotVTOLLand(args)
	if args.key == string.byte("X") then
		self.VTOLLand = false
	end
end

function ReverseThrust:ActivateThrust(args)

	if args.input ~= Action.PlaneDecTrust or Game:GetState() ~= GUIState.Game or not LocalPlayer:InVehicle() or LocalPlayer:GetValue("nofuel") then return end
	
	if not self.silly and not self.VTOLLand then
	
		local vehicle = LocalPlayer:GetVehicle()
		
		if self.planes[vehicle:GetModelId()] and LocalPlayer == vehicle:GetDriver() then
		
			local velocity = vehicle:GetLinearVelocity()
			local angle = vehicle:GetAngle()
			local forwards_speed = -(-angle * velocity).z
			
			if forwards_speed < 1 and not self.stop.timer then
				self.stop.timer = Timer()
				self.network.timer = Timer()
			elseif forwards_speed > 1 and self.stop.timer then
				self.stop.timer = nil
				self.network.timer = nil
			end
			
			if self.stop.timer then

				if self.network.timer:GetMilliseconds() > self.network.delay and self.stop.timer:GetMilliseconds() > self.stop.delay and forwards_speed > -self.max_reverse_speed then
								
					args = {}
					args.vehicle = vehicle
					args.velocity = velocity + angle * Vector3(0, 0, 1)

					Network:Send("ReverseThrust", args)	
					self.network.timer:Restart()
					
				end
				
			end
				
		end
		
	elseif self.silly then
	
		local vehicle = LocalPlayer:GetVehicle()
		
		if self.planes[vehicle:GetModelId()] and LocalPlayer == vehicle:GetDriver() then
		
			local velocity = vehicle:GetLinearVelocity()
			local angle = vehicle:GetAngle()
			local forwards_speed = -(-angle * velocity).z
			
			if not self.network.timer then
				self.network.timer = Timer()
			end
			
			if self.network.timer then

				if self.network.timer:GetMilliseconds() > self.network.delay then
								
					args = {}
					args.vehicle = vehicle
					args.velocity = velocity + angle * Vector3(0, 0, 1)

					Network:Send("ReverseThrust", args)						
					self.network.timer:Restart()
					
				end
				
			end
				
		end
		
	end

end

ReverseThrust = ReverseThrust()