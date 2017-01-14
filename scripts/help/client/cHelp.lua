-- Written by Philpax

class 'Help'

function Help:__init()
	self.active = false

	self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.4, 0.515 ) )
	self.window:SetPositionRel( 
		Vector2( 0.5, 0.5 ) - self.window:GetSizeRel()/2 )
	self.window:SetTitle( "Help Window" )
	self.window:SetVisible( self.active )

	self.tab_control = TabControl.Create( self.window )
	self.tab_control:SetHeight( 200 )
	self.tab_control:SetDock( GwenPosition.Fill )
	--self.tab_control:SetTabStripPosition( GwenPosition.Left )

	self.tabs = {}

	self.changes = {}

	Events:Subscribe( "KeyUp", self,
		self.KeyUp )

	Events:Subscribe( "LocalPlayerInput", self,
		self.LocalPlayerInput )

	self.window:Subscribe( "WindowClosed", self, 
		self.WindowClosed )

	Events:Subscribe( "HelpAddItem", self, 
		self.AddItem )

	Events:Subscribe( "HelpRemoveItem", self, 
		self.RemoveItem )

	Events:Subscribe( "LocalPlayerChat", self, self.PlayerChat )
	Events:Subscribe( "ModulesLoad", self, self.GeneralLoad )
    Events:Subscribe( "ModuleUnload", self, self.GeneralUnload )
    Events:Subscribe( "ModulesLoad", self, self.VehicleLoad )
    Events:Subscribe( "ModuleUnload", self, self.VehicleUnload )
    Events:Subscribe( "ModulesLoad", self, self.ModLoad )
    Network:Subscribe( "GroupReceive", self, self.ModAdd )
    Events:Subscribe( "ModuleUnload", self, self.ModUnload )
    Events:Subscribe( "ModulesLoad", self, self.Changelog )
    Network:Subscribe( "ChangelogEntry", self, self.AddChange )
    Events:Subscribe( "ModuleUnload", self, self.ChangelogUnload )
    Events:Subscribe( "ModulesLoad", self, self.CreditsLoad )
    Events:Subscribe( "ModuleUnload", self, self.CreditsUnload )
end

function Help:GeneralLoad()
	Events:Fire( "HelpAddItem",
        {
            name = "Commands and Hotkeys",
            text = 
                " B -- Buy Menu\n"..
             --   " H -- Detonate C4\n"..
				" V -- Warp Menu\n"..
				" 2 -- Binoculars\n"..
				" 4 -- ATC Menu\n"..
				" 5 -- Toggle Firstperson\n"..
				" 6 -- Hold to dive\n"..
				" 7 -- Toggle bank GUI\n"..
				"F2 -- Toggle World Map with Player Locations\n"..
				"F3 -- Toggle Chat\n"..
				"F5 -- Help Menu\n"..
				"F6 -- Player List\n"..
				"F7 -- MOTD & Rules\n"..
				"F8 -- Player colour\n"..
			--	" Right Mouse -- Plant C4\n"..
				" \n"..
				" \n"..
				"/me [text] -- The original /me command!\n"..
				"/fp -- Toggles firstperson view.\n"..
				"/fpa -- When /fp is enabled this will cause the camera to move with the player's head.\n"..
				"/fparms -- When /fp is enabled this will mean that your body wont be in the way in vehicles.\n"..
				"/killfeed -- Toggle killfeed.\n"..
				"/tags -- Opens player tag menu.\n"..
				"/pvp -- You can't shoot or be shot. On by default. (Toggle)\n"..
				"/map -- Toggle teleport map.\n"..
				"/showonmap -- Toggle you map marker (also disables your teleport map).\n"..
				"/infotext -- Toggle the infotext at the bottom of the screen.\n"..
				"/stats -- Displays your player statistics.\n"..
				"/local -- Toggle local chat (range 100m).\n"..
				"/suicide -- Kill yourself!\n"..
				"/staff -- Show online staff\n"..
				"/atcmessages -- Toggle incoming ATC messages.\n"..
				" \n"..
				" \n"..
				"To activate the wingsuit press shift when skydiving or parachuting."
        } )
end

function Help:GeneralUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "Command and Hotkeys"
        } )
end

function Help:VehicleLoad()
	Events:Fire( "HelpAddItem",
        {
            name = "Vehicle Specifics",
            text = 
                "E -- Hold and scroll to required seat to enter.\n"..
				"Z -- Autopilot/Cruise Control (dependent on vehicle).\n"..
				"Q -- Smoke trail for planes.\n"..
				"G -- Enter large vehicles when all seats are taken.\n"..
				" \n"..
				" \n"..
				"/reverse -- Toggles reversing on planes.\n"..
				"/VTOL -- To receive VTOL instructions.\n"..
				"/jethud -- Toggles jethud when flying.\n"..
				"/speedo -- Opens speedometer configuration menu.\n"..
				"/siphon -- Siphon fuel from one vehicle to another.\n"..
				"/sw [X co-ord] [Y co-ord] -- Set a waypoint.\n"..
				"/cw -- Clear your waypoint.\n"..
				"/mayday -- Send out a blackbox broadcast."
        } )
end

function Help:VehicleUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "Command and Hotkeys"
        } )
end

function Help:ModLoad()
	Network:Send( "RankRequest" )
end

function Help:ModAdd(group)
	if group == "Developer" or group == "Admin" or group == "Owner" then
		Events:Fire( "HelpAddItem",
        	{
            	name = "Staff Helpmenu",
            	text = 
                	"P -- Toggle the admin panel.\n"..
                	" \n"..
                	"You have access to:\n"..
                	" \n"..
                	"EVERYTHING :)\n"..
					" \n"..
					"/getsteamid [playername] -- Gets their steamid.\n"..
					" \n"..
					"/warn [text] -- Sends a server wide message."
        	} )
	elseif group == "Moderator" then
		Events:Fire( "HelpAddItem",
        	{
            	name = "Staff Helpmenu",
            	text = 
                	"P -- Toggle the admin panel.\n"..
                	" \n"..
                	"You have access to:\n"..
                	"kick,\n"..
                	"ban,\n"..
					"mute,\n"..
					"kill,\n"..
					"warp,\n"..
					"spectate,\n"..
					"setmodel,\n"..
					"sethealth,\n"..
					"setmoney,\n"..
					"giveweapon,\n"..
					"warpto,\n"..
					"freeze,\n"..
					"givemoney,\n"..
					"givevehicle,\n"..
					"repairvehicle,\n"..
					"destroyvehicle,\n"..
					"setvehiclecolour,\n"..
					"shout,\n"..
					"settime,\n"..
					"setweather,\n"..
					"adminchat.\n"..
					" \n"..
					"/getsteamid [playername] -- Gets their steamid."
        	} )
	elseif group == "TrialMod" then
		Events:Fire( "HelpAddItem",
        	{
            	name = "Staff Helpmenu",
            	text = 
                	"P -- Toggle the admin panel.\n"..
                	" \n"..
                	"You have access to:\n"..
                	"kick,\n"..
					"mute,\n"..
					"warp,\n"..
					"giveweapon,\n"..
					"warpto,\n"..
					"freeze,\n"..
					"givevehicle,\n"..
					"repairvehicle,\n"..
					"destroyvehicle,\n"..
					"setvehiclecolour,\n"..
					"shout,\n"..
					"adminchat.\n"..
					" \n"..
					"/getsteamid [playername] -- Gets their steamid."
        	} )
	end
end

function Help:ModUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "Staff Helpmenu"
        } )
end

function Help:Changelog()

	if self.tabs["Changelog"] ~= nil then
		self:ChangelogUnload()
	end

	local page = self.tab_control:AddPage( "Changelog" )
	page:SetPadding( Vector2(0, 0), Vector2( 0, 30 ) )
	self.table = SortedList.Create( page:GetPage() )
	self.table:SetDock( GwenPosition.Fill )
	self.table:AddColumn( "Date", 60 )
	self.table:AddColumn( "Change Type", 90 )
	self.table:AddColumn( "Description" )

	local change_reset_button = Button.Create( page:GetPage() )
	change_reset_button:SetText( "Reset Sorting (Original State)" )
	change_reset_button:SetDock( GwenPosition.Bottom )
	change_reset_button:SetEnabled( true )
	change_reset_button:Subscribe( "Press", function() self:ResetChangelogSort() end )

	Network:Send( "RequestTable" )

	self.tabs["Changelog"] = page

end

function Help:AddChange(item)

	local row = self.table:AddItem( item[1] )
			row:SetCellText(1, item[2] )
			row:SetCellText(2, item[3] )

	self.changes[item[1]] = row

end

function Help:ChangelogUnload()

	self.tabs["Changelog"]:GetPage():Remove()
	self.tab_control:RemovePage( self.tabs["Changelog"] )
	self.tabs["Changelog"] = nil

	if self.table then

		self.table:Remove()

	end

end

function Help:ResetChangelogSort()

	self.table:Clear()
	Network:Send( "RequestTable" )

end

function Help:CreditsLoad()
	Events:Fire( "HelpAddItem",
        {
            name = "Credits",
            text = 
                "Thanks to Garmelon for...\n"..
				"   Original Admin Script \n"..
                "   Original ATC Map script \n"..
                "   Countless other tweaks and improvements \n"..
                "   Being a great guy. <3 \n"..
				" \n"..
				" \n"..
				"Thanks to Dom2364 for...\n"..
                "   Original ATC script \n"..
                "   Pretty much enabling this server to be a thing \n"..
                "   Being a great guy. <3 \n"..
                " \n"..
				" \n"..
				"Thanks to Sinister Rectus for...\n"..
                "   Improved ATC Map script \n"..
                "   I recon every script on this server was once looked at by SR \n"..
                "   Being a great guy. <3 \n"..
                " \n"..
				" \n"..
				"Thanks to tally for...\n"..
                "   Many Many MANY scripts of all shapes and sizes \n"..
                "   Countless other tweaks and improvements \n"..
                "   Being an essential part of the Admin team \n"..
                "   Being a great guy. <3 \n"..
                " \n"..
				" \n"..
                "Thanks to WalrusBug! for...\n"..
                "   Being an essential part of the Admin team \n"..
                "   Running EVERY server to do with this community (extra <3 for being the sysadmin) \n"..
                "   Being a great guy. <3 \n"..
                " \n"..
				" \n"..
                "Thanks to Henrikx for...\n"..
                "   Being an essential part of the Admin team \n"..
                "   Running the website & forums \n"..
                "   Being a great guy. <3 \n"..
                " \n"..
				" \n"..
                "Thanks to ALL OTHER STAFF; both present and past for...\n"..
                "   Making this server possible \n"..
                "   Doing a great job moderating the server \n"..
                "   Being great guys. <3 <3 <3 \n"..
                " \n"..
                " \n"..
                "Mega thanks to all from m.kiwi (Owner)"
        } )
end

function Help:CreditsUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "Credits"
        } )
end

function Help:GetActive()
	return self.active
end

function Help:SetActive( state )
	self.active = state
	self.window:SetVisible( self.active )
	Mouse:SetVisible( self.active )
end

function Help:PlayerChat( args )
	local words = args.text:split(" ")
	if words[1] == "/help" then
		self:SetActive( not self:GetActive() )
		return false
	else 
		return true
	end
end

function Help:KeyUp( args )
	if args.key == VirtualKey.F5 then
		self:SetActive( not self:GetActive() )
	end
end

function Help:LocalPlayerInput( args )
	if self:GetActive() and Game:GetState() == GUIState.Game then
		return false
	end
end

function Help:WindowClosed( args )
	self:SetActive( false )
end

function Help:AddItem( args )
	if self.tabs[args.name] ~= nil then
		self:RemoveItem( args )
	end

	local tab_button = self.tab_control:AddPage( args.name )

	local page = tab_button:GetPage()

	local scroll_control = ScrollControl.Create( page )
	scroll_control:SetMargin( Vector2( 4, 4 ), Vector2( 4, 4 ) )
	scroll_control:SetScrollable( false, true )
	scroll_control:SetDock( GwenPosition.Fill )

	local label = Label.Create( scroll_control )
	-- Ugly hack to make the text not render under the scrollbar.
	label:SetPadding( Vector2( 0, 0 ), Vector2( 14, 0 ) )
	label:SetText( args.text )
	label:SetWrap( true )
	
	-- Ugly hack to get word wrapping with ScrollControl working decently.
	label:Subscribe( "Render" , function(label)
		label:SetWidth( label:GetParent():GetWidth() )
		label:SizeToContents()
	end)

	self.tabs[args.name] = tab_button
end

function Help:RemoveItem( args )
	if self.tabs[args.name] == nil then return end

	self.tabs[args.name]:GetPage():Remove()
	self.tab_control:RemovePage( self.tabs[args.name] )
	self.tabs[args.name] = nil
end

help = Help()