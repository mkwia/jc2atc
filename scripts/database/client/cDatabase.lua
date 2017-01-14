class 'Database'

function Database:__init()
		
	self.active_threshold = 1 -- seconds
	self.idle_threshold = 10 -- seconds
	
	self.idle_timer = Timer()
	self.idle_time = 0
	self.active_timer = Timer()
	self.active_time = 0

	Events:Subscribe("PreTick", self, self.OnPreTick)
	Events:Subscribe("LocalPlayerInput", self, self.OnLocalPlayerInput)

end

function Database:OnPreTick()

	if self.active_timer then-- and not LocalPlayer:GetValue("AFK") then
		if self.active_timer:GetSeconds() >= self.active_threshold then
			self.active_time = self.active_time + self.active_threshold
			self.active_timer:Restart()
		end
		if self.idle_timer:GetSeconds() >= self.idle_threshold then
			self.active_timer = nil
		end
	end
	
	if self.active_time >= 60 then -- Sends a one minute update to the server
		Network:Send("PlaytimeUpdate")
		self.active_time = 0
	end
	
end

function Database:OnLocalPlayerInput()

	if self.idle_timer then self.idle_timer:Restart() end -- Restart is faster than the timer check
	if not self.active_timer then self.active_timer = Timer() end

end

Database = Database()