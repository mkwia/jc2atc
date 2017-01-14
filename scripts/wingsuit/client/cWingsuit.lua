class 'Wingsuit'

function Wingsuit:__init()

	self.singleshift = true -- Enables single shifting to toggle wingsuit.
	self.superman = false -- Enables superman physics (disables custom grapple)
	self.grapple = true -- Enables custom grapple while gliding
	self.rolls = true -- Enables barrel rolls
	self.draw = true -- Enables drawing speed and altitude
	
	self.default_speed = 51 -- 51 m/s default
	self.default_vertical_speed = -2.4 -- -5 m/s default
	
	self.max_speed = 300 -- 300 m/s default, for superman mode
	self.min_speed = 1 -- 1 m/s default, for superman mode

	self.max_speed_real = 110 -- 92.64 m/s default
	self.min_speed_real = 24.35 -- 24.35 m/s default
	self.airresistance_real = 0.07 -- 0.06 m/s default
	
	self.tether_length = 150 -- meters
	self.yaw_gain = 1.5
	self.yaw = 0

	self.camera = 1
	
	self.speed = self.default_speed
	self.vertical_speed = self.default_vertical_speed

	self.angle = nil
	
	self.blacklist = {
		actions = { -- Actions to block while wingsuit is active
			[Action.LookUp] = true,
			[Action.LookDown] = true,
			[Action.LookLeft] = true,
			[Action.LookRight] = true
		},
		animations = { -- Disallow activation during these base states
			[AnimationState.SDead] = true,
			--[AnimationState.SUnfoldParachuteHorizontal] = true,
			--[AnimationState.SUnfoldParachuteVertical] = true,
			[AnimationState.SPullOpenParachuteVertical] = true
		}
	}
	
	self.whitelist = { -- Allow instant activation during these base states
		animations = {
			[AnimationState.SSkydive] = true,
			[AnimationState.SParachute] = true,
			[AnimationState.SReelFlight] = true
		}
	}
	
	self.timers = {
		grapple = Timer()
	}
	
	self.subs = {}
	
	Events:Subscribe("KeyUp", self, self.Activate)
	--[[Events:Subscribe("ModulesLoad", self, self.AddHelp)
	Events:Subscribe("ModuleUnload", self, self.RemoveHelp)]]

end

function Wingsuit:Activate(args)

	if Game:GetState() ~= GUIState.Game then return end

	if not self.singleshift then

		if args.key == VirtualKey.Shift and not self.subs.camera and LocalPlayer:GetState() == PlayerState.OnFoot then
	
			local bs = LocalPlayer:GetBaseState()
			if self.blacklist.animations[bs] then return end

			if not self.timers.activate or self.timers.activate:GetMilliseconds() > 500 then

				self.timers.activate = Timer()

			elseif self.timers.activate:GetMilliseconds() < 500 then

				self.timers.activate = nil
			
				if self.whitelist.animations[bs] then
				
					self.timers.camera_start = Timer()
					self.speed = LocalPlayer:GetLinearVelocity():Length()
					if self.speed < self.min_speed/2 then
						self.speed = self.min_speed * 3/4
					end
					if bs == AnimationState.SReelFlight then
						LocalPlayer:SetBaseState(6)
						LocalPlayer:SetLinearVelocity(LocalPlayer:GetLinearVelocity() + Vector3(0, 10, 0))
					end
					LocalPlayer:SetBaseState(AnimationState.SSkydive)
					self.subs.wings = Events:Subscribe("GameRender", self, self.DrawWings)
					self.subs.velocity = Events:Subscribe("Render", self, self.SetVelocity)
					self.subs.camera = Events:Subscribe("CalcView", self, self.Camera)
					self.subs.glide = Events:Subscribe("InputPoll", self, self.Glide)
					self.subs.input = Events:Subscribe("LocalPlayerInput", self, self.Input)
				
				elseif self.superman then
		
					local timer = Timer()
					self.timers.camera_start = Timer()
					self.speed = self.default_speed
					self.subs.camera = Events:Subscribe("CalcView", self, self.Camera)
					self.subs.input = Events:Subscribe("LocalPlayerInput", self, self.Input)
					self.subs.wings = Events:Subscribe("GameRender", self, self.DrawWings)
					self.subs.delay = Events:Subscribe("PreTick", function()
						local dt = timer:GetMilliseconds()
						LocalPlayer:SetBaseState(AnimationState.SSkydive)
						LocalPlayer:SetLinearVelocity(LocalPlayer:GetAngle() * math.lerp(Vector3(0, self.speed, 0), Vector3(0, 0, -self.speed), dt / 1000))
						if dt > 1000 then
							Events:Unsubscribe(self.subs.delay)
							self.subs.delay = nil
							self.subs.velocity = Events:Subscribe("Render", self, self.SetVelocity)
						end
					end)

				end
			
			end

		elseif args.key == VirtualKey.Control and self.subs.camera and not self.timers.camera_start and not self.timers.camera_stop then
	
			if not self.timers.activate or self.timers.activate:GetMilliseconds() > 500 then
				self.timers.activate = Timer()
			elseif self.timers.activate:GetMilliseconds() < 500 then
				local ray = Physics:Raycast(LocalPlayer:GetPosition(), LocalPlayer:GetAngle() * Vector3(0, -1, -1), 0, 50)
				if ray.distance < 50 then
					LocalPlayer:SetBaseState(AnimationState.SFall)
				else
					LocalPlayer:SetBaseState(AnimationState.SSkydive)
				end
				self.timers.camera_stop = Timer()
			end

		end

	else

		if args.key == VirtualKey.Shift and not self.subs.camera and LocalPlayer:GetState() == PlayerState.OnFoot then
	
			local bs = LocalPlayer:GetBaseState()
			local las = LocalPlayer:GetLeftArmState()
			if self.blacklist.animations[bs] then return end
			
			if self.whitelist.animations[bs] then
				
				self.timers.camera_start = Timer()
				self.speed = LocalPlayer:GetLinearVelocity():Length()
				if self.speed < self.min_speed/2 then
					self.speed = self.min_speed * 3/4
				end
				if bs == AnimationState.SReelFlight then
					LocalPlayer:SetBaseState(6)
					LocalPlayer:SetLinearVelocity(LocalPlayer:GetLinearVelocity() + Vector3(0, 10, 0))
				end
				LocalPlayer:SetBaseState(AnimationState.SSkydive)
				self.subs.wings = Events:Subscribe("GameRender", self, self.DrawWings)
				self.subs.velocity = Events:Subscribe("Render", self, self.SetVelocity)
				self.subs.camera = Events:Subscribe("CalcView", self, self.Camera)
				self.subs.glide = Events:Subscribe("InputPoll", self, self.Glide)
				self.subs.input = Events:Subscribe("LocalPlayerInput", self, self.Input)
				
			elseif self.superman then
		
				local timer = Timer()
				self.timers.camera_start = Timer()
				self.speed = self.default_speed
				self.subs.camera = Events:Subscribe("CalcView", self, self.Camera)
				self.subs.input = Events:Subscribe("LocalPlayerInput", self, self.Input)
				self.subs.wings = Events:Subscribe("GameRender", self, self.DrawWings)
				self.subs.delay = Events:Subscribe("PreTick", function()
					local dt = timer:GetMilliseconds()
					LocalPlayer:SetBaseState(AnimationState.SSkydive)
					LocalPlayer:SetLinearVelocity(LocalPlayer:GetAngle() * math.lerp(Vector3(0, self.speed, 0), Vector3(0, 0, -self.speed), dt / 1000))
					if dt > 1000 then
						Events:Unsubscribe(self.subs.delay)
						self.subs.delay = nil
						self.subs.velocity = Events:Subscribe("Render", self, self.SetVelocity)
					end
				end)

			end
			
		elseif args.key == VirtualKey.Shift and self.subs.camera and not self.timers.camera_start and not self.timers.camera_stop then
	
			local ray = Physics:Raycast(LocalPlayer:GetPosition(), LocalPlayer:GetAngle() * Vector3(0, -1, -1), 0, 50)
			if ray.distance < 50 then
				LocalPlayer:SetBaseState(AnimationState.SFall)
			else
				LocalPlayer:SetBaseState(AnimationState.SSkydive)
			end
			self.timers.camera_stop = Timer()

		end

	end

	if args.key == string.byte("C") and self.subs.camera then
	
		if self.camera < 5 then
			self.camera = self.camera + 1
		else
			self.camera = 1
		end
		
	end

end

function Wingsuit:DrawWings()

	self.dt = math.abs((Game:GetTime() + 12) % 24 - 12) / 12

	local bones = LocalPlayer:GetBones()
	local color = LocalPlayer:GetColor()
	
	local r = math.lerp(0.1 * color.r, color.r, self.dt)
	local g = math.lerp(0.1 * color.g, color.g, self.dt)
	local b = math.lerp(0.1 * color.b, color.b, self.dt)
	
	color = Color(r, g, b)
	
	Render:FillTriangle(
		bones.ragdoll_RightArm.position, 
		bones.ragdoll_RightForeArm.position,
		bones.ragdoll_RightUpLeg.position, 
		color
	)
	
	Render:FillTriangle(
		bones.ragdoll_LeftArm.position, 
		bones.ragdoll_LeftForeArm.position,
		bones.ragdoll_LeftUpLeg.position, 
		color
	)

	Render:FillTriangle(
		bones.ragdoll_LeftLeg.position, 
		bones.ragdoll_RightLeg.position,
		bones.ragdoll_Hips.position, 
		color
	)
	
	Render:DrawLine(
		bones.ragdoll_RightForeArm.position,
		bones.ragdoll_RightUpLeg.position,
		Color.Black
	)
	
	Render:DrawLine(
		bones.ragdoll_LeftForeArm.position,
		bones.ragdoll_LeftUpLeg.position,
		Color.Black
	)

	Render:DrawLine(
		bones.ragdoll_LeftLeg.position,
		bones.ragdoll_RightLeg.position,
		Color.Black
	)

end

function Wingsuit:SetVelocity()
	
	local bs = LocalPlayer:GetBaseState()

	if bs ~= AnimationState.SSkydive and bs ~= AnimationState.SSkydiveDash and bs ~= AnimationState.SPullOpenParachuteVertical and bs ~= AnimationState.SPullOpenParachuteHorizontal then
		self:Abort()
		return
	end
	
	if self.superman then
	
		if Key:IsDown(VirtualKey.Shift) and self.speed < self.max_speed then
			self.speed = self.speed + 1
		elseif Key:IsDown(VirtualKey.Control) and self.speed > self.min_speed then
			self.speed = self.speed - 1
		end
			
		local speed = self.speed - math.sin(LocalPlayer:GetAngle().pitch) * 20
		LocalPlayer:SetLinearVelocity(LocalPlayer:GetAngle() * Vector3(0, 0, -speed))
		
	else
	
		self.speed = self.speed - math.sin(LocalPlayer:GetAngle().pitch) * 0.25 - self.airresistance_real
		if Key:IsDown(VirtualKey.Control) and self.speed > self.min_speed_real then
			self.speed = self.speed - 0.1
		end
		if self.speed > self.max_speed_real then
			self.speed = self.max_speed_real - 1
		end
		if self.speed < self.min_speed_real - 10 then
			self.speed = self.min_speed_real - 10
		end
		LocalPlayer:SetLinearVelocity((LocalPlayer:GetAngle() * Vector3(0, 0, -self.speed)) + Vector3(0, self.vertical_speed, 0))
	
	end

	if self.draw then
	
		local speed = LocalPlayer:GetLinearVelocity():Length() * 3.6
		if speed > self.max_speed_real * 3.6 then
			speed = self.max_speed_real * 3.6
		end
		local player_pos = LocalPlayer:GetPosition()
		local altitude = player_pos.y - (math.max(200, Physics:GetTerrainHeight(player_pos)))
		local hud_str = string.format("%i km/h   %i m", speed, altitude)
		local screen_pos = Vector2(0.5 * Render.Width - 0.5 * Render:GetTextWidth(hud_str, TextSize.Large), 5)
	
		Render:DrawText(screen_pos + Vector2(1,1), hud_str, Color.Black, TextSize.Large)
		Render:DrawText(screen_pos, hud_str, Color.White, TextSize.Large)

	end
	
	if not self.rolls or self.subs.grapple then return end
	
	if Key:IsDown(string.byte("X")) then
		if not self.roll_left then
			self.roll_left = true
			if not self.subs.roll_left then
				local timer = Timer()
				LocalPlayer:SetBaseState(AnimationState.SSkydiveDash)
				self.subs.roll_left = Events:Subscribe("PreTick", function()
					if timer:GetMilliseconds() > 750 then
						LocalPlayer:SetBaseState(AnimationState.SSkydive)
						Events:Unsubscribe(self.subs.roll_left)
						self.subs.roll_left = nil
					end
				end)
			end
		end
	else
		self.roll_left = nil
	end
	
	--[[if Input:GetValue(Action.MoveRight) > 0 then
		if not self.roll_right then
			self.roll_right = true
			if not self.timers.roll_right then
				self.timers.roll_right = Timer()
			elseif self.timers.roll_right:GetMilliseconds() < 500 then
				if not self.subs.roll_right then
					local timer = Timer()
					LocalPlayer:SetBaseState(AnimationState.SSkydiveDash)
					self.subs.roll_right = Events:Subscribe("PreTick", function()
						if timer:GetMilliseconds() > 750 then
							LocalPlayer:SetBaseState(AnimationState.SSkydive)
							Events:Unsubscribe(self.subs.roll_right)
							self.subs.roll_right = nil
						end
					end)
				end
				self.timers.roll_right = nil
			else
				self.timers.roll_right = nil
			end
		end
	else
		self.roll_right = nil
	end]]

	if self.superman then return end

	if not self.hit then

		if LocalPlayer:GetAngle().pitch > -0.25 and LocalPlayer:GetLinearVelocity():Length() <= self.min_speed_real then
			if Chat:GetActive() then
				Chat:SetEnabled(false)
				Chat:SetEnabled(true)
			end

		end

	end

end

function Wingsuit:Glide()
	
	if self.superman then return end

	if not self.hit then

		if LocalPlayer:GetAngle().pitch > -0.25 and LocalPlayer:GetLinearVelocity():Length() <= self.min_speed_real then
			if Chat:GetActive() then
				Chat:SetEnabled(false)
				Chat:SetEnabled(true)
			end
			Input:SetValue(Action.MoveBackward, 0)
			Input:SetValue(Action.MoveForward, 1)
		end
	
	else

		if Input:GetValue(Action.MoveBackward) < 0.2 then
			Input:SetValue(Action.MoveBackward, 0.2)
		end

		if self.yaw < 0 then
			Input:SetValue(Action.MoveLeft, -self.yaw_gain * self.yaw)
		elseif self.yaw > 0 then
			Input:SetValue(Action.MoveRight, self.yaw_gain * self.yaw)
		end

	end

	if self.subs.roll_left then

		Input:SetValue(Action.MoveBackward, 0)
		Input:SetValue(Action.MoveForward, 0)
		Input:SetValue(Action.MoveLeft, 0)
		Input:SetValue(Action.MoveRight, 0)

		if not self.angle then

			self.angle = LocalPlayer:GetAngle()

		else

			LocalPlayer:SetAngle(self.angle)

		end

	else

		if self.angle then

			self.angle = nil

		end

	end

end

function Wingsuit:Input(args)

	if Game:GetState() ~= GUIState.Game then return end
	
	if not self.superman and self.grapple and args.input == Action.FireGrapple then
	
		if self.subs.roll_left or self.subs.roll_right or self.timers.grapple:GetMilliseconds() < 500 then return false end

		if self.subs.grapple then self:EndGrapple() return false end
		
		local angle = LocalPlayer:GetAngle()
		
		if angle.pitch < -0.2 * math.pi then return false end
			
		LocalPlayer:SetLeftArmState(399)
		
		self.timers.grapple = Timer()
		local direction = Camera:GetAngle() * Vector3.Forward
		
		self.effect = ClientEffect.Create(AssetLocation.Game, {
			effect_id = 11,
			position = LocalPlayer:GetPosition(),
			angle = Angle()
		})

		self.subs.grapple = Events:Subscribe("GameRender", function()
			
			local dt = self.timers.grapple:GetMilliseconds()			
			local bone_pos = LocalPlayer:GetBonePosition("ragdoll_LeftForeArm")
			
			local color = Color(100, 100, 100)
			local r = math.lerp(0.5 * color.r, color.r, self.dt)
			local g = math.lerp(0.5 * color.g, color.g, self.dt)
			local b = math.lerp(0.5 * color.b, color.b, self.dt)

			if not self.hit then
			
				local distance = self.tether_length * dt / 500
				local ray = Physics:Raycast(bone_pos, direction, 0, distance)
				
				Render:DrawLine(bone_pos, ray.position, Color(r, g, b, 192))

				if ray.distance < distance - 0.1 and ray.position.y > 199  then
					self.hit = ray.position
				end

				if dt > 500 then self:EndGrapple() end

			else

				Render:DrawLine(bone_pos, self.hit, Color(r, g, b, 192))
			 
				local yaw1 = math.atan2(bone_pos.x - self.hit.x, bone_pos.z - self.hit.z)
				local yaw2 = angle.yaw
				self.yaw = (yaw2 - yaw1 + math.pi) % (2 * math.pi) - math.pi

				self.speed = self.speed + 0.4

				if dt > 1500 or math.abs(self.yaw) > 0.2 * math.pi or Vector3.DistanceSqr(bone_pos, self.hit) > self.tether_length^2 then 
					self:EndGrapple() 
				end
	
			end
			
		end)
	
		return false
	
	end
		
	if self.blacklist.actions[args.input] then return false end

end

function Wingsuit:EndGrapple()

	self.timers.grapple:Restart()
	self.effect:Remove()
	LocalPlayer:SetLeftArmState(384)
	Events:Unsubscribe(self.subs.grapple)
	self.subs.grapple = nil
	self.hit = nil
	self.yaw = 0
	
end

function Wingsuit:Abort()

	if self.subs.wings then 
		Events:Unsubscribe(self.subs.wings)
		self.subs.wings = nil
	end
	if self.subs.velocity then 
		Events:Unsubscribe(self.subs.velocity) 
		self.subs.velocity = nil
	end
	if self.subs.glide then 
		Events:Unsubscribe(self.subs.glide) 
		self.subs.glide = nil
	end
	if self.subs.input then 
		Events:Unsubscribe(self.subs.input)
		self.subs.input = nil
	end
	if self.subs.camera then
		Events:Unsubscribe(self.subs.camera)
		self.subs.camera = nil
	end

end

function Wingsuit:Camera()

	local player_pos = LocalPlayer:GetPosition()
	local player_angle = LocalPlayer:GetAngle()
	local vector
	
	if self.camera == 1 then
		vector = Vector3(0, 2, 7)
	elseif self.camera == 2 then
		vector = Vector3(0, 1, 1)
	elseif self.camera == 3 then
		vector = Vector3(0, 0.5, -1)
	elseif self.camera == 4 then
		vector = Vector3(0, 1, 10)
	end

	if self.timers.camera_start then
	
		local dt = self.timers.camera_start:GetMilliseconds()

		if self.camera < 5 then
			Camera:SetPosition(math.lerp(Camera:GetPosition(), player_pos + player_angle * vector, dt / 1000))
			Camera:SetAngle(Angle.Slerp(Camera:GetAngle(), player_angle, 0.9 * dt / 1000))
		end

		if dt >= 1000 then 
			self.timers.camera_start = nil 
		end
		
	elseif self.timers.camera_stop then
	
		local dt = self.timers.camera_stop:GetMilliseconds()

		if self.camera < 5 then
			Camera:SetPosition(math.lerp(player_pos + player_angle * vector, Camera:GetPosition(), dt / 1000))
			Camera:SetAngle(Angle.Slerp(Camera:GetAngle(), player_angle, 0.9 - 0.9 * dt / 1000))
		end

		if dt >= 1000 then 
			self.timers.camera_stop = nil
			self:Abort()
		end	
		
	else
		
		if self.camera < 5 then
			Camera:SetPosition(player_pos + player_angle * vector)
			Camera:SetAngle(Angle.Slerp(Camera:GetAngle(), player_angle, 0.9))
		end
		
	end

end

--[[function Wingsuit:AddHelp()

	local text
	
	if self.superman then
		text = 
			"This wingsuit allows you to fly around Panau unencumbered." .. 
			"\n\nTo activate, double-tap Shift. To de-activate, double-tap Ctrl." ..
			"\nWhile flying, hold Shift to speed up or Ctrl to slow down."
	else
		if self.grapple then
			text = 
				"The wingsuit allows you to glide gently from the sky."
			if self.singleshift then
				text =
					text.."\n\nTo activate, tap Shift while sky-diving or parachuting." ..
					"\nTo de-activate, tap Shift."..
					"\nHold Control to slow down."
			else
				text =
					text.."\n\nTo activate, double-tap Shift while sky-diving or parachuting." ..
					"\nTo de-activate, double-tap Ctrl."
			end
				text =
					text.."\nUse your grapple to propel yourself across land."	
		else
			text = 
				"The wingsuit allows you to fly around Panau unencumbered."
			if self.singleshift then
				text =
					text.."\n\nTo activate, tap Shift while sky-diving or parachuting." ..
					"\nTo de-activate, tap Shift."
			else
				text =
					text.."\n\nTo activate, double-tap Shift while sky-diving or parachuting." ..
					"\nTo de-activate, double-tap Ctrl."
			end
		end			
	end
	
	if self.rolls then
		text = text .. "\nDouble-tap left or right to roll."
	end

	Events:Fire("HelpAddItem", {
		name = "Wingsuit",
		text = text
	})

end

function Wingsuit:RemoveHelp()

	Events:Fire("HelpRemoveItem", {
		name = "Wingsuit"
	})

end]]

Wingsuit = Wingsuit()