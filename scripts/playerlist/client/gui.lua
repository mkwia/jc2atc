-- Written by JaTochNietDan, with slight modifications by Philpax

class 'ListGUI'

function ListGUI:__init()
	self.active = false

	self.LastTick = 0
	self.ReceivedLastUpdate = true

	self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.25, 0.8 ) )
	self.window:SetPositionRel( Vector2( 0.5, 0.5 ) - 
								self.window:GetSizeRel()/2 )
	self.window:SetTitle( "Total Players: 0" )
	self.window:SetVisible( self.active )

	self.list = SortedList.Create( self.window )
	self.list:SetDock( GwenPosition.Fill )
	
	self.list:SetMargin( Vector2( 4, 4 ), Vector2( 4, 0 ) )
	self.list:AddColumn( "ID", 32 )
	self.list:AddColumn( "Name" )
	self.list:AddColumn( "Bounty", 48)
	self.list:AddColumn( "Ping", 48 )
	self.list:SetButtonsVisible( true )

	self.filter = TextBox.Create( self.window )
	self.filter:SetDock( GwenPosition.Bottom )
	self.filter:SetSize( Vector2( self.window:GetSize().x, 32 ) )	
	self.filter:SetMargin( Vector2( 4, 4 ), Vector2( 4, 4 ) )
	self.filter:Subscribe( "TextChanged", self, self.FilterChanged )

	self.filterGlobal = LabeledCheckBox.Create( self.window )
	self.filterGlobal:SetDock( GwenPosition.Bottom )
	self.filterGlobal:SetSize( Vector2( self.window:GetSize().x, 20 ) )	
	self.filterGlobal:SetMargin( Vector2( 4, 4 ), Vector2( 4, 0 ) )
	self.filterGlobal:GetLabel():SetText( "Search entire name" )
	self.filterGlobal:GetCheckBox():SetChecked( true )
	self.filterGlobal:GetCheckBox():Subscribe( "CheckChanged", self, self.FilterChanged )
	
	self.player = nil

	self.PlayerCount = 0
	self.Rows = {}

	self.sort_dir = false
	self.last_column = -1

	self.list:Subscribe( "SortPress",
		function(button)
			self.sort_dir = not self.sort_dir
		end)

	self.list:SetSort( 
		function( column, a, b )
			if column ~= -1 then
				self.last_column = column
			elseif column == -1 and self.last_column ~= -1 then
				column = self.last_column
			else
				column = 0
			end

			local a_value = a:GetCellText(column)
			local b_value = b:GetCellText(column)

			if column == 0 or column == 2 then
				local a_num = tonumber(a_value)
				local b_num = tonumber(b_value)

				if a_num ~= nil and b_num ~= nil then
					a_value = a_num
					b_value = b_num
				end
			end

			if self.sort_dir then
				return a_value > b_value
			else
				return a_value < b_value
			end
		end )

	self:AddPlayer(LocalPlayer)

	for player in Client:GetPlayers() do
		self:AddPlayer(player)
	end

	self.window:SetTitle("Total Players: "..tostring(self.PlayerCount))

	Network:Subscribe("UpdatePings", self, self.UpdatePings)

	Events:Subscribe( "KeyUp", self, self.KeyUp )
	Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	Events:Subscribe( "PostTick", self, self.PostTick )
	Events:Subscribe( "PlayerJoin", self, self.PlayerJoin )
	Events:Subscribe( "PlayerQuit", self, self.PlayerQuit )
	self.list:Subscribe( "RowSelected", self, self.ChoosePlayer )
	Events:Subscribe( "Render", self, self.DrawAvatar )

	self.window:Subscribe( "WindowClosed", self, self.CloseClicked )
end

function ListGUI:GetActive()
	return self.active
end

function ListGUI:SetActive( state )
	self.active = state
	self.window:SetVisible( self.active )
	Mouse:SetVisible( self.active )
end

function ListGUI:KeyUp( args )
	if args.key == VirtualKey.F6 then
		self:SetActive( not self:GetActive() )
		if not self:GetActive() then
			self.list:UnselectAll()
			self.player = nil
		end
	end
end

function ListGUI:LocalPlayerInput( args )
	if self:GetActive() and Game:GetState() == GUIState.Game then
		return false
	end
end

function ListGUI:UpdatePings( list )
	for ID, ping in pairs(list) do
		if self.Rows[ID] ~= nil then
			self.Rows[ID]:SetCellText( 3, tostring(ping) )
			local bounty = Player.GetById(ID):GetValue( "Bounty" )
			if bounty ~= nil then
				self.Rows[ID]:SetCellText( 2, "£"..tostring(bounty) )
			else
				self.Rows[ID]:SetCellText( 2, "£0" )
			end
		end
	end

	self.ReceivedLastUpdate = true
end

function ListGUI:PlayerJoin( args )
	self:AddPlayer(args.player)
	self.window:SetTitle("Total Players: "..tostring(self.PlayerCount))
end

function ListGUI:PlayerQuit( args )
	self:RemovePlayer(args.player)
	self.window:SetTitle("Total Players: "..tostring(self.PlayerCount))
end

function ListGUI:ChoosePlayer()
        local p = self.list:GetSelectedRow():GetCellText(0)
        self.player = Player.GetById( tonumber(p) )
end

function ListGUI:DrawAvatar()
    if not self.active or self.player == nil then return end
    local rs = Render.Size
    self.player:GetAvatar(2):Draw( Vector2( rs.x * 0.85 - 100, rs.y * 0.5 - 100 ), Vector2( 200, 200 ), Vector2.Zero, Vector2.One)  
end

function ListGUI:CloseClicked( args )
	self:SetActive( false )
	self.list:UnselectAll()
	self.player = nil
end

function ListGUI:AddPlayer( player )
	self.PlayerCount = self.PlayerCount + 1

	local item = self.list:AddItem( tostring(player:GetId()) )
	item:SetCellText( 1, player:GetName() )
	item:SetCellText( 2, "£0")
	item:SetCellText( 3, "..." )

	self.Rows[player:GetId()] = item

	local text = self.filter:GetText():lower()
	local visible = (string.find( item:GetCellText(1):lower(), text ) == 1)

	item:SetVisible( visible )
end

function ListGUI:RemovePlayer( player )
	self.PlayerCount = self.PlayerCount - 1

	if self.Rows[player:GetId()] == nil then return end

	self.list:RemoveItem( self.Rows[player:GetId()] )
	self.Rows[player:GetId()] = nil
end

function ListGUI:FilterChanged()
	local text = self.filter:GetText():lower()

	local globalSearch = self.filterGlobal:GetCheckBox():GetChecked()

	if text:len() > 0 then
		for k, v in pairs(self.Rows) do
			--[[
			Use a plain text search, instead of a pattern search, to determine
			whether the string is within this row.
			If pattern searching is used, pattern characters such as '[' and ']'
			in names cause this function to error.
			]]

			local index = v:GetCellText(1):lower():find( text, 1, true )
			if globalSearch then
				v:SetVisible( index ~= nil )
			else
				v:SetVisible( index == 1 )
			end
		end
	else
		for k, v in pairs(self.Rows) do
			v:SetVisible( true )
		end
	end
end

function ListGUI:PostTick()
	if self:GetActive() then
		if Client:GetElapsedSeconds() - self.LastTick >= 5 then
			Network:Send("SendPingList", LocalPlayer)

			self.LastTick = Client:GetElapsedSeconds()
			self.ReceivedLastUpdate = false
		end
	end
end

list = ListGUI()