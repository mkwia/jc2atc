class "planewarnings"

function planewarnings:__init()

	self.enabled = false

	self.planes = {[24] = true, [30] = true, [34] = true, [39] = true, [51] = true, [59] = true, [81] = true, [85] = true}

	self.fontsize = 30

	self.timer = Timer()

	Events:Subscribe("LocalPlayerChat", self, self.Chat)
	Events:Subscribe("PostTick", self, self.warningtimer)
	Events:Subscribe("Render", self, self.Render)

end

function planewarnings:Chat(args)

	if args.text == "/gpws" then

		self.enabled = not self.enabled

		Chat:Print("GPWS Enabled: "..tostring(self.enabled), Color.White)

		self.string = nil

		self.adjust = nil

		return false

	end

end

function planewarnings:warningtimer()

	if self.timer:GetSeconds() >= 1 then

		if LocalPlayer:InVehicle() then

			local vehicle = LocalPlayer:GetVehicle()
			local modelid = vehicle:GetModelId()

			if self.planes[modelid] then

				if modelid ~= 30 or (modelid == 30 and not Key:IsDown(string.byte("X"))) then

					if Physics:Raycast(vehicle:GetPosition(), vehicle:GetAngle() * Vector3.Forward, 1, 100).distance < 100 then

						self.string = "SINK RATE, PULL UP"

						self.adjust = Render:GetTextSize(self.string, self.fontsize)

					elseif Physics:Raycast(vehicle:GetPosition(), Vector3.Down, 1, 100).distance < 20 then

						self.string = "TERRAIN, PULL UP"

						self.adjust = Render:GetTextSize(self.string, self.fontsize)

					elseif vehicle:GetLinearVelocity():Length() <= 28 and Physics:Raycast(vehicle:GetPosition(), Vector3.Down, 1, 1000).distance > 20 then

						self.string = "STALLING"

						self.adjust = Render:GetTextSize(self.string, self.fontsize)

					else

						self.string = nil

						self.adjust = nil

					end

				else

					self.string = nil

					self.adjust = nil

				end

			end

		end

		self.timer:Restart()

	end

end

function planewarnings:Render()

	if self.enabled then

		if LocalPlayer:InVehicle() then

			local vehicle = LocalPlayer:GetVehicle()
			local modelid = vehicle:GetModelId()

			if self.planes[modelid] then

				if self.string ~= nil and self.adjust ~= nil and self.timer:GetMilliseconds() < 750 and self.timer:GetMilliseconds() > 250 then

					Render:DrawText(Vector2(Render.Size.x/2 - self.adjust.x/2, Render.Size.y/2 - self.adjust.y/2), self.string, Color.Red, self.fontsize)

				end

			end

		end

	end

end

planewarnings = planewarnings()