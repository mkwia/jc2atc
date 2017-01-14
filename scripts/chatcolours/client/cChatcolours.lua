class "chatcolours"

function chatcolours:__init()
	self.enabled = false

	self.presstimer = Timer()

	self.window = Window.Create()
	self.picker = HSVColorPicker.Create(self.window)
	self.picker:SetSize(Vector2(420, 260))
	self.window:SetSize(Vector2(0.3 * 1368, 0.375 * 768))
	--self.window:SetMargin(Vector2(0, 0), Vector2(0, 50))
	self.window:SetPositionRel(Vector2(0.5, 0.5) - self.window:GetSizeRel()/2)
	self.window:SetTitle("Chat Colour")
	self.window:SetVisible(false)
	self.window:Subscribe("WindowClosed", self, self.WindowClosed)
	self.picker:Subscribe("ColorChanged", self, self.Select)

	Events:Subscribe("KeyUp", self, self.toggle)
	Events:Subscribe("LocalPlayerInput", self, self.LocalPlayerInput)
end

function chatcolours:WindowClosed()
	Mouse:SetVisible(false)
	self.enabled = false
end

function chatcolours:toggle(args)
	if Game:GetState() == GUIState.Game then
		if args.key == VirtualKey.F8 then
			self.enabled = not self.enabled
		end
		if self.enabled then
			self.window:SetVisible(true)
			Mouse:SetVisible(true)
		else
			self.window:SetVisible(false)
			Mouse:SetVisible(false)
		end
	else
		self.window:SetVisible(false)
		Mouse:SetVisible(false)
	end
end

function chatcolours:LocalPlayerInput(args)
	if self.enabled and Game:GetState() == GUIState.Game then
		return false
	end
end

function chatcolours:Select(args)
	if self.presstimer:GetSeconds() >= 1 then
		if self.picker:GetColor() == Color(255, 255, 255, 255) then
			Chat:Print("You can't use that colour!", Color.Red)
			args = 
			{
			colour = Color(0, 0, 0, 255),
			player = LocalPlayer
			}
			Network:Send("colourchange", args)
		end
		Chat:Print("Chat colour changed.", self.picker:GetColor())
		self.presstimer:Restart()
	end
	args = 
		{
		colour = self.picker:GetColor(),
		player = LocalPlayer
		}
	Network:Send("colourchange", args)
end

chatcolours = chatcolours()