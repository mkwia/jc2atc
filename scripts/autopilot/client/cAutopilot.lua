class 'Autopilot'

function Autopilot:__init()

	self.colors = {Color.Orange, Color.Silver} -- Color scheme
	
	self.draw_target = true -- Whether to draw a target indicator for target-hold		
	self.draw_approach = true -- Whether to draw a path for approach-hold
		
	self.two_keys = false -- If false then panel toggle button toggles both the panel and mouse
	self.panel_toggle_button = "Z"
	self.mouse_toggle_button = "M"
	
	local vehicle = LocalPlayer:GetVehicle()
	if IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer then
		local model = vehicle:GetModelId()
		if planes[model] and planes[model].available then
			self.vehicle = vehicle
			self.model = model
		end
	end

	self:InitGUI()
	
	Events:Subscribe("ModuleLoad", self, self.WindowResize)
	Events:Subscribe("ResolutionChange", self, self.ResolutionChange)
	Events:Subscribe("KeyUp", self, self.PanelOpen)
	Events:Subscribe("LocalPlayerInput", self, self.InputBlock)
	Events:Subscribe("LocalPlayerEnterVehicle", self, self.EnterPlane)
	Events:Subscribe("LocalPlayerExitVehicle", self, self.ExitPlane)
	Events:Subscribe("EntityDespawn", self, self.PlaneDespawn)
	
	Events:Subscribe("InputPoll", self, self.Input)
	Events:Subscribe("GameRender", self, self.DrawApproach)
	Events:Subscribe("Render", self, self.DrawTarget)
	
end

function Autopilot:InitGUI()

	self.text_scale = 0.03
	
	self.gui = {}
	
	self.gui.window = Window.Create()
	self.gui.position = Vector2(0.63, 0.04)
	self.gui.size = Vector2(0.28, 0.28)
	self.gui.button_size = Vector2(0.22, 0.095)
	self.gui.button_position = Vector2(0, 0.105)
	self.gui.label_size = Vector2(0.16, self.gui.button_size.y)
	self.gui.slider_size = Vector2(0.31, self.gui.button_size.y)
	
	self.gui.window:SetTitle("Autopilot Panel")
	self.gui.window:SetVisible(false)
	self.gui.window:SetClosable(false)
	
	self.gui.window:SetSizeRel(self.gui.size)
	self.gui.window:SetPositionRel(self.gui.position)
	
	self.gui.line = Rectangle.Create(self.gui.window)
	self.gui.line:SetColor(Color(64, 64, 64))
	
	self.gui.st = {}
	
	self.gui.st.window = Window.Create()	
	self.gui.st.window:SetSizeRel(self.gui.size)
	self.gui.st.window:SetPosition(self.gui.window:GetPosition() + Vector2(0, self.gui.window:GetHeight()))
	
	self.gui.st.window:SetTitle("")
	self.gui.st.window:SetVisible(false)
	self.gui.st.window:SetClosable(false)
	
	for k in pairs(units) do -- Units settings
		if #units[k] > 1 then
			self.gui.st[k] = {}
			self.gui.st[k].label = Label.Create(self.gui.st.window)
			self.gui.st[k].label:SetText(k:sub(1,1):upper()..k:sub(2))
			for i, v in ipairs(units[k]) do
				self.gui.st[k][i] = LabeledRadioButton.Create(self.gui.st.window)
				self.gui.st[k][i]:GetLabel():SetText(v[1])
				self.gui.st[k][i]:GetLabel():SetMouseInputEnabled(false)
				self.gui.st[k][i]:GetRadioButton():Subscribe("Checked", function(args)
					settings[k] = i
					for _, w in ipairs(self.gui.st[k]) do
						if w ~= self.gui.st[k][i] then
							w:GetRadioButton():SetChecked(false)
						end
					end
				end)
			end
			self.gui.st[k][settings[k]]:GetRadioButton():SetChecked(true)
		end
	end
	
	self.gui.st.ap = {}
	self.gui.st.ap.gain = {}
	self.gui.st.ap.input = {}
	
	self.gui.st.ap.gain.label = Label.Create(self.gui.st.window)
	self.gui.st.ap.gain.label:SetText("Gain")
	
	self.gui.st.ap.input.label = Label.Create(self.gui.st.window)
	self.gui.st.ap.input.label:SetText("Input")
	
	self.gui.ap = {}
		
	for i in ipairs(config) do -- Main GUI window
	
		table.insert(self.gui.ap, {})
		local v = self.gui.ap[#self.gui.ap]
	
		v.button = Button.Create(self.gui.window)
		v.button:SetText(config[i].name)
		v.button:SetToggleable(true)
		v.button:SetTextPressedColor(self.colors[1])
		
		if config[i].setting then
			
			v.label = Label.Create(self.gui.window)
			v.slider = HorizontalSlider.Create(self.gui.window)
			v.slider:SetRange(config[i].min_setting, config[i].max_setting)
			v.slider:Subscribe("ValueChanged", function(args)
				config[i].setting = args:GetValue()				
			end)
			
			if config[i].step then
				v.slider:SetClampToNotches(true)
				v.slider:SetNotchCount((config[i].max_setting-config[i].min_setting) / config[i].step)
			end
			
			v.inc = Button.Create(self.gui.window)
			v.dec = Button.Create(self.gui.window)
			v.inc:SetText("+")
			v.dec:SetText("-")
			v.inc:Subscribe("Press", function()
				if config[i].setting < config[i].max_setting then
					config[i].setting = config[i].setting + (config[i].step or 1)
				end			
			end)
			v.dec:Subscribe("Press", function()
				if config[i].setting > config[i].min_setting then
					config[i].setting = config[i].setting - (config[i].step or 1)
				end
			end)
			
			v.quick = Button.Create(self.gui.window)
			v.quick:SetText(config[i].quick)
			
			table.insert(self.gui.st.ap, {})
			local k = #self.gui.st.ap
			local w = self.gui.st.ap[k]
			self.gui.st.ap[k] = Label.Create(self.gui.st.window)
			self.gui.st.ap[k]:SetText(config[i].name)
			self.gui.st.ap.gain[k] = TextBoxNumeric.Create(self.gui.st.window)
			self.gui.st.ap.gain[k]:SetNegativeAllowed(false)
			self.gui.st.ap.gain[k]:SetText(tostring(config[i].gain))
			self.gui.st.ap.gain[k]:Subscribe("TextChanged", function()
				config[i].gain = tonumber(self.gui.st.ap.gain[k]:GetText()) or 0
			end)
			if config[i].input then
				self.gui.st.ap.input[k] = TextBoxNumeric.Create(self.gui.st.window)
				self.gui.st.ap.input[k]:SetNegativeAllowed(false)
				self.gui.st.ap.input[k]:SetText(tostring(config[i].input))
				self.gui.st.ap.input[k]:Subscribe("TextChanged", function()
					config[i].input = tonumber(self.gui.st.ap.input[k]:GetText()) or 0
				end)
			end
		end
		
	end
	
	self.gui.ap[1].button:Subscribe("ToggleOn", self, self.APOn)
	self.gui.ap[2].button:Subscribe("ToggleOn", self, self.RHOn)
	self.gui.ap[3].button:Subscribe("ToggleOn", self, self.PHOn)
	self.gui.ap[4].button:Subscribe("ToggleOn", self, self.HHOn)
	self.gui.ap[5].button:Subscribe("ToggleOn", self, self.AHOn)
	self.gui.ap[6].button:Subscribe("ToggleOn", self, self.SHOn)
	self.gui.ap[7].button:Subscribe("ToggleOn", self, self.WHOn)
	self.gui.ap[8].button:Subscribe("ToggleOn", self, self.OHOn)
	self.gui.ap[9].button:Subscribe("ToggleOn", self, self.THOn)
	self.gui.ap[10].button:Subscribe("ToggleOn", self, self.STOn)
	
	self.gui.ap[1].button:Subscribe("ToggleOff", self, self.APOff)
	self.gui.ap[2].button:Subscribe("ToggleOff", self, self.RHOff)
	self.gui.ap[3].button:Subscribe("ToggleOff", self, self.PHOff)
	self.gui.ap[4].button:Subscribe("ToggleOff", self, self.HHOff)
	self.gui.ap[5].button:Subscribe("ToggleOff", self, self.AHOff)
	self.gui.ap[6].button:Subscribe("ToggleOff", self, self.SHOff)
	self.gui.ap[7].button:Subscribe("ToggleOff", self, self.WHOff)
	self.gui.ap[8].button:Subscribe("ToggleOff", self, self.OHOff)
	self.gui.ap[9].button:Subscribe("ToggleOff", self, self.THOff)
	self.gui.ap[10].button:Subscribe("ToggleOff", self, self.STOff)
	
	self.gui.ap[2].quick:Subscribe("Press", self, self.RHQuick)
	self.gui.ap[3].quick:Subscribe("Press", self, self.PHQuick)
	self.gui.ap[4].quick:Subscribe("Press", self, self.HHQuick)
	self.gui.ap[5].quick:Subscribe("Press", self, self.AHQuick)
	self.gui.ap[6].quick:Subscribe("Press", self, self.SHQuick)
	
	self.gui.window:Subscribe("Render", self, self.WindowUpdate)
	self.gui.window:Subscribe("Resize", self, self.WindowResize)
	self.gui.st.window:Subscribe("Resize", self, self.WindowResize)

end

function Autopilot:RHQuick()
	config[2].setting = 0
	self:RHOn()
end

function Autopilot:PHQuick()
	config[3].setting = 0
	self:PHOn()
end

function Autopilot:HHQuick()
	config[4].setting = self.vehicle:GetHeading()
	self:HHOn()
end

function Autopilot:AHQuick()
	config[5].setting = self.vehicle:GetAltitude()
	self:AHOn()
end

function Autopilot:SHQuick()
	config[6].setting = planes[self.model].cruise_speed
	self:SHOn()
end

function Autopilot:APOn()
	config[1].on = true
end

function Autopilot:RHOn()
	if not self.scanning then
		self:APOn()
		config[2].on = true
	end
end

function Autopilot:PHOn()
	if not self.scanning then
		self:APOn()
		config[3].on = true
	end
end

function Autopilot:HHOn()
	if not self.scanning then
		self:RHOn()
		config[4].on = true
	end
end

function Autopilot:AHOn()
	if not self.scanning and not config[9].on then
		self:PHOn()
		config[5].on = true
	end
end

function Autopilot:SHOn()
	if not self.scanning then
		self:APOn()
		config[6].on = true
	end
end

function Autopilot:WHOn()
	local waypoint, marker = Waypoint:GetPosition()
	if marker then
		self:OHOff()
		self:THOff()
		self:HHOn()
		config[7].on = true
	else
		Chat:Print("Waypoint not set.", self.colors[2])
	end
end

function Autopilot:OHOn()
	self:APOn()
	self:SHOff()
	self:WHOff()
	self:THOff()
	config[8].on = true
	self.scanning = true
	self.approach_timer = Timer()
	Chat:Print("Scanning for runways...", self.colors[2])
end

function Autopilot:THOn()
	self:APOn()
	self:SHOff()
	self:WHOff()
	self:OHOff()
	config[9].on = true
	self.scanning = true
	self.target_timer = Timer()
	Chat:Print("Scanning for targets...", self.colors[2])
end

function Autopilot:STOn()
	self:WindowResize()
	config[10].on = true
	self.gui.st.window:SetVisible(true)
end

function Autopilot:APOff()
	self:OHOff()
	self:THOff()
	self:AHOff()
	self:WHOff()
	self:HHOff()
	self:PHOff()
	self:RHOff()
	self:SHOff()
	config[1].on = false
end

function Autopilot:RHOff()
	if not config[7].on and not config[4].on then
		config[2].on = false
	end
end

function Autopilot:PHOff()
	if not config[5].on and not config[9].on and not config[8].on then
		config[3].on = false
	end
end

function Autopilot:HHOff()
	if not config[7].on and not config[9].on and not config[8].on then
		config[4].on = false
		self:RHOff()
	end
end

function Autopilot:AHOff()
	if not config[8].on then
		config[5].on = false
		self:PHOff()
	end
end

function Autopilot:SHOff()
	if not config[9].on and not config[8].on then
		config[6].on = false
	end
end

function Autopilot:WHOff()
	if config[7].on then
		config[7].on = false
		if not config[8].on then
			self:HHOff()
		end
	end
end

function Autopilot:OHOff()
	if config[8].on then
		config[8].on = false
		self.scanning = nil
		self.approach = nil
		self.flare = nil
		if not config[7].on then
			self:HHOff()
		end
		self:AHOff()
		self:SHOff()
	end
end

function Autopilot:THOff()
	if config[9].on then
		config[9].on = false
		self.scanning = nil
		self.target = nil
		self:HHOff()
		self:PHOff()
		self:SHOff()
	end
end

function Autopilot:STOff()
	config[10].on = false
	self.gui.st.window:SetVisible(false)
end

function Autopilot:PanelOpen(args) -- Subscribed to KeyUp

	if self.two_keys then
	
		if args.key == string.byte(self.panel_toggle_button) and self.vehicle then
			self.gui.window:SetVisible(not self.gui.window:GetVisible())
			self:STOff()
		end
		
		if args.key == string.byte(self.mouse_toggle_button) and self.vehicle then
			Mouse:SetVisible(not Mouse:GetVisible())
		end
		
	else
	
		if args.key == string.byte(self.panel_toggle_button) and self.vehicle then
			self.gui.window:SetVisible(not self.gui.window:GetVisible())
			self:STOff()
			Mouse:SetVisible(self.gui.window:GetVisible())
		end
		
	end
	
end

function Autopilot:InputBlock(args) -- Subscribed to LocalPlayerInput

	local i = args.input

	if Mouse:GetVisible() then
		if i == 3 or i == 4 or i == 5 or i == 6 or i == 138 or i == 139 then
			return false
		end
	end
	if config[2].on then
		if i == 60 or i == 61 then
			return false
		end
	end
	if config[3].on then
		if i == 58 or i == 59 then
			return false
		end
	end
	if config[6].on then
		if i == 64 or i == 65 then
			return false
		end
	end

end

function Autopilot:ResolutionChange() -- Subscribe to ResolutionChange

	self.gui.window:SetSizeRel(self.gui.size)
	self.gui.window:SetPositionRel(self.gui.position)
	self.gui.st.window:SetSize(self.gui.window:GetSize())
	self.gui.st.window:SetPosition(self.gui.window:GetPosition() + Vector2(0, self.gui.window:GetHeight()))
	self:WindowResize()

end
	
function Autopilot:WindowResize() -- Subscribed to ModuleLoad and Window Resize

	local window_size = self.gui.window:GetSize()

	self.text_size = window_size:Length() * self.text_scale
	
	for i = 1, 6 do
		self.gui.ap[i].button:SetPositionRel(self.gui.button_position * (i-1))
	end
	
	self.gui.ap[7].button:SetPositionRel(self.gui.button_position * 7)
	self.gui.ap[8].button:SetPositionRel(Vector2(self.gui.button_position.x + self.gui.button_size.x * 1.05, self.gui.button_position.y * 7))
	self.gui.ap[9].button:SetPositionRel(Vector2(self.gui.button_position.x + self.gui.button_size.x * 2.10, self.gui.button_position.y * 7))
	self.gui.ap[10].button:SetPositionRel(Vector2(self.gui.button_position.x + self.gui.button_size.x * 3.41, self.gui.button_position.y * 7))
	
	self.gui.line:SetPositionRel(self.gui.button_position * 6.35)
	self.gui.line:SetSizeRel(Vector2(window_size.x, self.gui.button_size.y * 0.2))
	
	for i, v in pairs(self.gui.ap) do

		v.button:SetSizeRel(self.gui.button_size)
		v.button:SetTextSize(self.text_size)
		
		if config[i].setting then
		
			v.label:SetSizeRel(self.gui.label_size)
			v.label:SetTextSize(self.text_size)
			v.label:SetPositionRel(v.button:GetPositionRel() + Vector2(v.button:GetWidthRel() * 1.06, v.button:GetHeightRel() * 0.2))
			
			v.slider:SetSizeRel(self.gui.slider_size)
			v.slider:SetPositionRel(v.label:GetPositionRel() + Vector2(v.label:GetWidthRel(), v.label:GetHeightRel() * -0.3))
			
			v.dec:SetSizeRel(Vector2(self.gui.button_size.x / 3.5, self.gui.button_size.y))
			v.dec:SetTextSize(self.text_size)
			v.dec:SetPositionRel(v.button:GetPositionRel() + Vector2(v.button:GetWidthRel() * 3.2, 0))
			
			v.inc:SetSizeRel(Vector2(self.gui.button_size.x / 3.5, self.gui.button_size.y))
			v.inc:SetTextSize(self.text_size)
			v.inc:SetPositionRel(v.dec:GetPositionRel() + Vector2(0.065, 0))
			
			v.quick:SetSizeRel(Vector2(self.gui.button_size.x / 1.5, self.gui.button_size.y))
			v.quick:SetTextSize(self.text_size)
			v.quick:SetPositionRel(v.inc:GetPositionRel() + Vector2(0.065, 0))
			
		end
	end
	
	local column1 = 0.03
	local column2 = 0.20
	local column3 = 0.50
	local column4 = 0.65
	local column5 = 0.80
	
	self.gui.st.window:SetSize(window_size)
	self.gui.st.window:SetPosition(self.gui.window:GetPosition() + Vector2(0, self.gui.window:GetHeight()))
	
	self.gui.st.distance.label:SetPositionRel(Vector2(column1, 0.08))
	self.gui.st.distance.label:SetTextSize(self.text_size)
	self.gui.st.distance.label:SizeToContents()
	for i, v in ipairs(self.gui.st.distance) do
		v:SetPositionRel(Vector2(column1, 0.2 + (i - 1) * 0.1))
		v:GetLabel():SetTextSize(self.text_size)
		v:GetLabel():SizeToContents()
	end
	
	self.gui.st.speed.label:SetPositionRel(Vector2(column2, 0.08))
	self.gui.st.speed.label:SetTextSize(self.text_size)
	self.gui.st.speed.label:SizeToContents()
	for i, v in ipairs(self.gui.st.speed) do
		v:SetPositionRel(Vector2(column2, 0.2 + (i - 1) * 0.1))
		v:GetLabel():SetTextSize(self.text_size)
		v:GetLabel():SizeToContents()
	end
	
	for i, v in ipairs(self.gui.st.ap) do
		v:SetPositionRel(Vector2(column3, 0.2 + (i - 1) * 0.1 + 0.02))
		v:SetTextSize(self.text_size)
		v:SizeToContents()
	end
	
	self.gui.st.ap.gain.label:SetPositionRel(Vector2(column4, 0.08))
	self.gui.st.ap.gain.label:SetTextSize(self.text_size)
	self.gui.st.ap.gain.label:SizeToContents()
	
	for i, v in ipairs(self.gui.st.ap.gain) do
		v:SetPositionRel(Vector2(column4, 0.2 + (i - 1) * 0.1))
		v:SetTextSize(self.text_size)
		v:SetWidth(self.text_size * 3)
		v:SetHeight(self.text_size * 1.5)
	end
	
	self.gui.st.ap.input.label:SetPositionRel(Vector2(column5, 0.08))
	self.gui.st.ap.input.label:SetTextSize(self.text_size)
	self.gui.st.ap.input.label:SizeToContents()
	
	for i, v in pairs(self.gui.st.ap.input) do
		if type(i) == "number" then
			v:SetPositionRel(Vector2(column5, 0.2 + (i - 1) * 0.1))
			v:SetTextSize(self.text_size)
			v:SetWidth(self.text_size * 3)
			v:SetHeight(self.text_size * 1.5)
		end
	end
	
end

function Autopilot:WindowUpdate() -- Subscribed to Window Render

	for k, v in pairs(self.gui.ap) do
		v.button:SetToggleState(config[k].on)
		if config[k].setting then
			v.label:SetText(string.format("%i%s", config[k].setting * units[config[k].units][settings[config[k].units]][2], units[config[k].units][settings[config[k].units]][1]))
			v.slider:SetValue(config[k].setting)		
		end
	end
		
end

function Autopilot:EnterPlane(args)
	
	if args.is_driver then
		local model = args.vehicle:GetModelId()
		if planes[model] and planes[model].available then
			self:APOff()
			self.vehicle = args.vehicle
			self.model = model
		end
	end
	
end

function Autopilot:ExitPlane(args)

	if self.vehicle then self:Disable() end

end

function Autopilot:PlaneDespawn(args)

	if args.entity.__type == "Vehicle" and self.vehicle and self.vehicle == args.entity then
		self:Disable()
	end

end

function Autopilot:Disable()

	self:APOff()
	self.vehicle = nil
	self.model = nil
	self.gui.window:SetVisible(false)
	self.gui.st.window:SetVisible(false)
	Mouse:SetVisible(false)

end

function Autopilot:Input() -- Subscribed to InputPoll

	if Game:GetState() ~= GUIState.Game or not IsValid(self.vehicle) then return end

	if config[2].on then self:RollHold() end
	if config[3].on then self:PitchHold() end
	if config[4].on then self:HeadingHold() end
	if config[5].on then self:AltitudeHold() end
	if config[6].on then self:SpeedHold() end
	if config[7].on then self:WaypointHold() end
	if config[8].on then self:ApproachHold() end
	if config[9].on then self:TargetHold() end

end

function Autopilot:RollHold()
	
	local roll = self.vehicle:GetRoll()
	
	local input = math.abs(roll - config[2].setting) * config[2].gain
	if input > config[2].input then input = config[2].input end
	
	if config[2].setting < roll then
		Input:SetValue(Action.PlaneTurnRight, input)
	elseif config[2].setting > roll then
		Input:SetValue(Action.PlaneTurnLeft, input)
	end
	
end

function Autopilot:PitchHold()
	
	local pitch = self.vehicle:GetPitch()

	local input = math.abs(pitch - config[3].setting) * config[3].gain
	if input > config[3].input then input = config[3].input end
	
	-- Deactivates if the plane is banked too far left or right.
	local abs_roll = math.abs(self.vehicle:GetRoll())
	
	if abs_roll < 60 then
		if config[3].setting > pitch then
			Input:SetValue(Action.PlanePitchUp, input)
		elseif config[3].setting < pitch then
			Input:SetValue(Action.PlanePitchDown, input)
		end
	elseif abs_roll > 120 then
		if config[3].setting > pitch then
			Input:SetValue(Action.PlanePitchDown, input)
		elseif config[3].setting < pitch then
			Input:SetValue(Action.PlanePitchUp, input)
		end
	end
	
end

function Autopilot:HeadingHold()
	
	local heading = self.vehicle:GetHeading()
	
	config[2].setting = DegreesDifference(config[4].setting, heading) * config[4].gain
	
	if config[2].setting > config[4].input then
		config[2].setting = config[4].input
	elseif config[2].setting < -config[4].input then
		config[2].setting = -config[4].input
	end
	
end

function Autopilot:AltitudeHold()
	
	config[3].setting = (config[5].setting - self.vehicle:GetAltitude() + config[5].bias) * config[5].gain
	
	if config[3].setting > config[5].input then
		config[3].setting = config[5].input
	elseif config[3].setting < -config[5].input then
		config[3].setting = -config[5].input
	end
	
end

function Autopilot:SpeedHold()
		
	local air_speed = self.vehicle:GetAirSpeed()
	
	local input = math.abs(air_speed - config[6].setting) * config[6].gain
	if input > config[6].input then input = config[6].input end
	
	if air_speed < config[6].setting and not config[8].on then
		Input:SetValue(Action.PlaneIncTrust, input)
	elseif air_speed > config[6].setting then
		Input:SetValue(Action.PlaneDecTrust, input)
	end
	
end

function Autopilot:WaypointHold()
	
	local waypoint, marker = Waypoint:GetPosition()
	
	if not marker then return self:WHOff() end
	
	self:FollowTargetXZ(waypoint)
	
end

function Autopilot:ApproachHold()
	
	if not self.approach and self.approach_timer:GetMilliseconds() > 1000 then
	
		local position = self.vehicle:GetPosition()
		local runway_name
		local runway_direction
		local airport_name
		local nearest_marker
		local nearest_marker_distance = math.huge
		
		for airport,runways in pairs(airports) do
			for runway in pairs(runways) do
			
				local near_marker = airports[airport][runway].near_marker
				local far_marker = airports[airport][runway].far_marker
				local distance = Vector3.DistanceSqr(position, near_marker)
					
				if distance < airports[airport][runway].glide_length^2 and distance < nearest_marker_distance then
					
					if math.deg(math.acos(Vector3.Dot(self.vehicle:GetAngle() * Vector3.Forward, (near_marker - position):Normalized()))) < 0.5 * planes[self.model].cone_angle then
						
						if math.deg(math.acos(Vector3.Dot(Angle(math.atan2(far_marker.x - near_marker.x, far_marker.z - near_marker.z), math.rad(airports[airport][runway].glide_pitch), 0) * Vector3.Forward, (position - near_marker):Normalized()))) < 0.5 * airports[airport][runway].cone_angle then
					
							nearest_marker_distance = distance
							nearest_marker = near_marker
							airport_name = airport
							runway_name = runway
							runway_direction = YawToHeading(math.deg(math.atan2(far_marker.x - near_marker.x, far_marker.z - near_marker.z)))
							
						end
						
					end
					
				end
				
			end	
		end
		
		if nearest_marker then
			self.scanning = nil
			self:HHOn()
			self:AHOn()
			self:SHOn()
			self.approach = {}
			Chat:Print("Approach to "..airport_name.." RWY"..runway_name.." set.", self.colors[1])
			self.approach.near_marker = airports[airport_name][runway_name].near_marker
			self.approach.far_marker = airports[airport_name][runway_name].far_marker
			self.approach.angle = Angle(math.rad(HeadingToYaw(runway_direction)), math.rad(airports[airport_name][runway_name].glide_pitch), 0)
			self.approach.sweep_yaw = Angle(math.rad(airports[airport_name][runway_name].cone_angle / 2), 0, 0)
			self.approach.glide_length = airports[airport_name][runway_name].glide_length
			-- self.approach.glide_pitch = airports[airport_name][runway_name].glide_pitch
			self.flare = nil
		end
		
		self.approach_timer:Restart()
	
	end
	
	if self.approach then

		local position = self.vehicle:GetPosition()
		
		if not self.flare then
			local distance = Vector3.Distance(self.approach.near_marker, position)
			if distance > planes[self.model].flare_distance then
				self.approach.farpoint = self.approach.near_marker + self.approach.angle * Vector3.Forward * distance
				config[5].setting = self.approach.farpoint.y - 200 - config[5].bias
				config[6].setting = math.min(math.lerp(planes[self.model].landing_speed, planes[self.model].cruise_speed, distance / planes[self.model].slow_distance), planes[self.model].cruise_speed)
				self.approach.target = math.lerp(self.approach.near_marker, self.approach.farpoint, 0.5)
				self:FollowTargetXZ(self.approach.target)
			else
				self.flare = true
				self:AHOff()
				self:PHOn()
				self.approach.target = self.approach.far_marker
				config[3].setting = planes[self.model].flare_pitch
				config[6].setting = planes[self.model].landing_speed
			end
		else
			local distance = Vector3.Distance(self.approach.far_marker, position)
			local length = Vector3.Distance(self.approach.far_marker, self.approach.near_marker)
			config[6].setting = math.min(math.lerp(0, planes[self.model].landing_speed, distance / length), planes[self.model].landing_speed)
			self:FollowTargetXZ(self.approach.target)
		end
		
	end
	
end

function Autopilot:DrawApproach() -- Subscribed to GameRender

	if config[8].on and self.draw_approach and self.approach then
	
		Render:DrawLine(self.approach.near_marker, self.approach.near_marker + self.approach.angle * Vector3.Forward * self.approach.glide_length, self.colors[1])
		Render:DrawLine(self.approach.near_marker, self.approach.near_marker + self.approach.angle * self.approach.sweep_yaw * Vector3.Forward * self.approach.glide_length, Color.Cyan)
		Render:DrawLine(self.approach.near_marker, self.approach.near_marker + self.approach.angle * -self.approach.sweep_yaw * Vector3.Forward * self.approach.glide_length, Color.Cyan)
	
	end

end

function Autopilot:TargetHold()
	
	if not self.target and self.target_timer:GetMilliseconds() > 1000 then
	
		local position = self.vehicle:GetPosition()
		local nearest_target = nil
		local nearest_target_distance = math.huge
		
		for target in Client:GetVehicles() do
		
			if IsValid(target) and target:GetClass() == VehicleClass.Air and target ~= self.vehicle and target:GetDriver() then
				
				local target_position = target:GetPosition()
				local target_distance = Vector3.DistanceSqr(position, target_position)
				
				if target_distance < nearest_target_distance then
					
					if math.deg(math.acos(Vector3.Dot(self.vehicle:GetAngle() * Vector3.Forward, (target_position - position):Normalized()))) < 0.5 * planes[self.model].cone_angle then
					
						nearest_target = target
						nearest_target_distance = target_distance

					end

				end
				
			end
			
		end
		
		if nearest_target then
			self.scanning = nil
			Chat:Print("Target acquired: "..tostring(nearest_target:GetDriver()), self.colors[1])
			self.target = {}
			self.target.vehicle = nearest_target
			self.target.follow_distance = 100
			self:SHOn()
			self:HHOn()
			self:PHOn()
		end	
		
		self.target_timer:Restart()
	
	end
	
	if self.target then
	
		if not IsValid(self.target.vehicle) or not self.target.vehicle:GetDriver() then
			Chat:Print("Target lost.", self.colors[1])
			return self:THOff()
		end
		
		self.target.position = self.target.vehicle:GetPosition()
		self.target.distance = Vector3.Distance(self.target.position, LocalPlayer:GetPosition())
		local bias = self.target.distance / self.target.follow_distance
		
		config[6].setting = math.clamp(bias * self.target.vehicle:GetLinearVelocity():Length() * 3.6, config[6].min_setting, config[6].max_setting)
		
		self:FollowTargetXZ(self.target.position)
		self:FollowTargetY(self.target.position)
		
	end

end

function Autopilot:DrawTarget() -- Subscribed to Render

	if config[9].on and self.draw_target and self.target and IsValid(self.target.vehicle) then

		local name = self.target.vehicle:GetName()
		local model = self.target.vehicle:GetModelId()
		local center = Render:WorldToScreen(self.target.position + self.target.vehicle:GetAngle() * Vector3.Up * 2)
		
		local n = Render.Height * self.text_scale
		local m = 0.75 * n
		
		Render:DrawLine(center + Vector2(-n, -m), center + Vector2(-n,  m), self.colors[1])
		Render:DrawLine(center + Vector2(-m,  n), center + Vector2( m,  n), self.colors[1])
		Render:DrawLine(center + Vector2( n,  m), center + Vector2( n, -m), self.colors[1])
		Render:DrawLine(center + Vector2( m, -n), center + Vector2(-m, -n), self.colors[1])
		
		local distance_string = string.format("%i%s", self.target.distance * units.distance[settings.distance][2], units.distance[settings.distance][1])
		Render:DrawText(center + Vector2(n * 1.25, -0.3 * Render:GetTextHeight(distance_string, 1.2 * self.text_size)), distance_string, self.colors[1], 1.2 * self.text_size)	
	
	end

end

function Autopilot:FollowTargetXZ(target_position) -- Heading-hold must be on

	local position = self.vehicle:GetPosition()
	local dx = position.x - target_position.x
	local dz = position.z - target_position.z
	
	config[4].setting = YawToHeading(math.deg(math.atan2(dx, dz)))

end

function Autopilot:FollowTargetY(target_position) -- Pitch-hold must be on

	local position = self.vehicle:GetPosition()
	local dy = position.y - target_position.y
	local distance = Vector3.Distance(position, target_position)
	
	config[3].setting = math.deg(math.asin(-dy / distance))

end

Autopilot = Autopilot()
