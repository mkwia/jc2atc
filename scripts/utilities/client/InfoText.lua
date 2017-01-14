class "InfoText"

function InfoText:__init()

	self.visible = true
	self.loaded = false
	
	self.text_scale = 0.009
	self.screen_size = Render.Size
	self.text_size = self.screen_size:Length() * self.text_scale

	Events:Subscribe("LocalPlayerChat", self, self.LocalPlayerChat)
	Events:Subscribe("ResolutionChange", self, self.ResolutionChange)
	Events:Subscribe("HideInfo", self, self.HidePanel)
	Events:Subscribe("ShowInfo", self, self.ShowPanel)
	Events:Subscribe("GameLoad", self, self.Load)
	Events:Subscribe("ModulesLoad", self, self.Load)
	-- Events:Subscribe("PostRender", self, self.OnPostRender)
	
	self.panel = Rectangle.Create()
	self.panel:SetColor(Color(0, 0, 0, 0))
	
	self.effects = {}
	
	self.effects.col1 = Rectangle.Create(self.panel)
	self.effects.col3 = Rectangle.Create(self.panel)
	self.effects.col4 = Rectangle.Create(self.panel)
	
	self.labels = {}
	
	self.labels.row1 = {}
	self.labels.row2 = {}
	self.labels.row3 = {}
	self.labels.row4 = {}
	
	self.labels.row1.col1 = Label.Create(self.panel)
	self.labels.row2.col1 = Label.Create(self.panel)
	self.labels.row3.col1 = Label.Create(self.panel)
	
	self.labels.row1.col2 = Label.Create(self.panel)
	self.labels.row2.col2 = Label.Create(self.panel)
	self.labels.row3.col2 = Label.Create(self.panel)
	
	self.labels.row1.col3 = Label.Create(self.panel)
	self.labels.row2.col3 = Label.Create(self.panel)
	self.labels.row3.col3 = Label.Create(self.panel)
	
	self.labels.row1.col4 = Label.Create(self.panel)
	self.labels.row2.col4 = Label.Create(self.panel)
	self.labels.row3.col4 = Label.Create(self.panel)
	
	self.labels.row1.col1:SetText("Social Media & Communication")
	self.labels.row2.col1:SetText("WEBSITE: jc2atc.ovh")
	self.labels.row3.col1:SetText("TEAMSPEAK: ts.jc2atc.ovh")
	
	self.labels.row1.col2:SetText("")
	self.labels.row2.col2:SetText("STEAM GROUP: JC2ATC")
	self.labels.row3.col2:SetText("TWITTER: @JC2ATC")
	
	self.labels.row1.col3:SetText("Technical & Administrative Announcements")
	self.labels.row2.col3:SetText("[TECH] Please report any bugs or glitches to us.")
	self.labels.row3.col3:SetText("[ADMIN] Tally and Dom are leaving, so do ^ this please!")
	
	self.labels.row1.col4:SetText("Tips & Scripts")
	self.labels.row2.col4:SetText("Press F5 for help.")
	self.labels.row3.col4:SetText("Type /infotext to disable this.")
	
	self.positions = {}
	
	self.positions.row1 = 0.32
	self.positions.row2 = 0.57
	self.positions.row3 = 0.80
	
	self.positions.col1 = 0.02
	self.positions.col2 = 0.22
	self.positions.col3 = 0.38
	self.positions.col4 = 0.75
	
	self:PanelResize()
	
	self.panel:SetVisible(false)
	
end

function InfoText:PanelResize()

	self.panel_size = Vector2(1, 0.10)
	self.panel_position = Vector2(0.5 - 0.5 * self.panel_size.x, 1 - self.panel_size.y)
	self.panel:SetSizeRel(self.panel_size)
	self.panel:SetPositionRel(self.panel_position)
	
	for row,_ in pairs(self.labels) do
		for col,label in pairs(_) do
			if row == "row1" then
				label:SetTextSize(self.text_size * 1.1)
			else
				label:SetTextColor(Color.Silver)
				label:SetTextSize(self.text_size)
			end
			label:SetPositionRel(Vector2(self.positions[col], self.positions[row]))
			label:SizeToContents()
		end
	end
	
	self.effects_size = Vector2(0.002, 1)
	for col,effect in pairs(self.effects) do
		effect:SetSizeRel(self.effects_size)
		effect:SetPositionRel(Vector2(self.labels.row1[col]:GetPositionRel().x - 0.005, self.labels.row1[col]:GetPositionRel().y))
	end

end

function InfoText:ShowPanel()
	self.panel:SetVisible(self.visible)
end

function InfoText:HidePanel()
	self.panel:SetVisible(false)
end

-- function InfoText:OnPostRender()

	-- if LocalPlayer:GetValue("F2Map") then return end

	-- if not self.infotext then return end

	-- local Screensize = Render.Size
	
	-- Render:DrawLine(Vector2(25, Screensize.y * 0.95), Vector2(25, Screensize.y * 1020), Color(255, 255, 255))
	-- Render:DrawText(Vector2(30, Screensize.y * 0.95), "Social Media & Communication", Color(255, 255, 255))
	-- Render:DrawText(Vector2(30, Screensize.y * 0.9675), "FORUMS: jc2atc.boards.net                         STEAM GROUP: JC2ATC     \nTEAMSPEAK: JC2ATC.basil.ovh                   TWITTER: Coming Soon", Color(170, 170, 170))

	-- Render:DrawLine(Vector2(615, Screensize.y * 0.95), Vector2(615, Screensize.y * 1020), Color(255, 255, 255))
	-- Render:DrawText(Vector2(620, Screensize.y * 0.95), "Techinal & Administrative Announcements", Color(255, 255, 255))
	-- Render:DrawText(Vector2(620, Screensize.y * 0.9675), "[TECH] It is a known issue that group features of the ATC do not work.\n[ADMIN] We are recruiting! More details on the forums.", Color(170, 170, 170))

	-- Render:DrawLine(Vector2(1235, Screensize.y * 0.95), Vector2(1235, 1035), Color(255, 255, 255))
	-- Render:DrawText(Vector2(1240, Screensize.y * 0.95), "Tips & Scripts", Color(255, 255, 255))
	-- Render:DrawText(Vector2(1240, Screensize.y * 0.9675), "Press F5 for help.\nType /infotext to disable this.", Color(170, 170, 170))
	
-- end

function InfoText:LocalPlayerChat(args)

	if args.text == "/infotext" then
		self.visible = not self.visible
		self.panel:SetVisible(self.visible)
		Chat:Print("InfoText toggled, use /infotext again to toggle back.", Color.Silver)
		return false
	end
	
end

function InfoText:ResolutionChange(args)

	self.screen_size = args.size
	self.text_size = self.screen_size:Length() * self.text_scale
	self:PanelResize()

end

function InfoText:Load()

	if not self.loaded then

		self.visible = true

		self.panel:SetVisible(true)

		self.loaded = true

	end

end

InfoText = InfoText()