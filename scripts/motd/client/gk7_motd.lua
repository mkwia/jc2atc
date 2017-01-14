-- Written by [GK7]Nakroma

class 'GK7Motd'
function GK7Motd:__init()
	-- Config
	self.servername = "ATC SERVER - END-OF-LIFE" -- Your server name
	self.buttonname = "Close MOTD" -- Name of your close button
	self.winsize = Vector2(1200, 600) -- Size of your MOTD (0.5 = 50% of your screen)
	self.header = "Use F7 to open/close this window." -- Header of your MOTD
	self.freezeplayer = true 	-- True/false if the player shouldn't be able
								-- to move while watching the MOTD (true recommended)
	self.pauseplayer = true	-- True/false if the player won't spawn until MOTD is closed
	self.motdcontent =  "\n\nWelcome to our server!\n\n\nRules:\n" ..   -- Content of your MOTD
						"1. Don't spam.\n" ..
						"2. Respect the admins and mods.\n" ..
                        "3. No impersonation! Impersonating a staff member is a banable offence.\n" ..
                        "4. Respect players.\n" ..
                        "5. Do not drive on or block runways, or ram or attack planes.\n" ..
                        "6. PvP is discouraged but not disallowed. This means you should only engage in PvP with people that want to, not random players.\n" ..
                        "7. Racism, sexism and other abuse will not be tolerated.\n" ..
                        --"6. English only please.\n"..
						"\nNotices:\n" ..
                        "THE SERVER HAS REACHED AN END-OF-LIFE\n" ..
                        "This means over the next few weeks we will begin to shut the server down for good.\n" ..
                        "We are negotiating what we will do with the project files, but we will possibly upload them to GitHub for other people to continue.\n" ..
												"I would like to thank everyone for their work, participation and support. With love, m.kiwi (Server Owner)."
	self.motdcontentsize = 20 -- Text size for the content of your MOTD
	-- How to add a line to self.motdcontent:
	   -- Put what you want to write in " "
	   -- On the first line do 2 \n\n (these make the text go on on the next line)
	   -- On the end of each line do 1 \n (for the next line)
	   -- After your second ", write a ..
	   -- If you're in the last line, DON'T write the ..
	self.button = true -- Should the MOTD be openable with a button
	self.button_key = VirtualKey.F7 -- F-Key: VirtualKey.Fx
									-- Other Key: "X"


	self.active = false

	self.window = Window.Create()
    self.window:SetSize( self.winsize )
    self.window:SetPositionRel( Vector2( 0.5, 0.5 ) - self.window:GetSizeRel()/2 )
    self.window:SetVisible( self.active )
    self.window:SetTitle( self.servername .. " - MOTD" )
    self.window:Subscribe( "WindowClosed", self, self.Close )

	local base1 = BaseWindow.Create( self.window )
    base1:SetDock( GwenPosition.Fill )
    base1:SetSize( Vector2( self.window:GetSize().x, self.window:GetSize().y ) )

	self.buy_button = Button.Create( base1 )
    self.buy_button:SetSize( Vector2( self.window:GetSize().x, 32 ) )
    self.buy_button:SetText( self.buttonname )
    self.buy_button:SetDock( GwenPosition.Bottom )
    self.buy_button:Subscribe( "Press", self, self.Close )

	-- Content: Header
	self.contents = Label.Create( base1 )
	self.contents:SetSize( Vector2( self.window:GetSize().x, 32 ) )
	self.contents:SetAlignment( GwenPosition.Center )
	self.contents:SetText( self.header )

	-- Content: Section
	self.contents2 = Label.Create( base1 )
	self.contents2:SetSize( Vector2( self.window:GetSize().x, 32 ) )
	self.contents2:SetText( self.motdcontent )
	self.contents2:SetTextSize( self.motdcontentsize )
	self.contents2:SetDock( GwenPosition.Left )

	-- Color Example
	-- You have to do this for every piece of content that has a different color
	-- Edit the SetColor with values from here: http://www.colorschemer.com/online.html
	-- Make sure to remove the -- and have a different number at XY for each content!

	--self.contentsXY = Label.Create( base1 )
	--self.contentsXY:SetSize( Vector2( self.window:GetSize().x, 32 ) )
	--self.contentsXY:SetText( "Example Headline 1\n" ) -- Edit your content with the same rules as in the config
	--self.contentsXY:SetDock( GwenPosition.Left )
	--self.contentsXY:SetTextColor( Color( 255, 255, 255 ) ) -- Edit the color here. Color( R, G, B )

	Events:Subscribe( "Render", self, self.Render )
	Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	Events:Subscribe( "KeyUp", self, self.KeyUp )
	Network:Subscribe( "MOTDActive", self, self.Display )
end

Events:Subscribe("ModuleLoad", function()
	args = {}
	args.player = LocalPlayer
	Network:Send("ClientLoaded", args)
end)

function GK7Motd:Display( onjoin )
	if onjoin and self.pauseplayer then
		Game:FireEvent("ply.pause")
	end
	self:Open()
end

function GK7Motd:KeyUp( args )
if self.button then
    if args.key == self.button_key then
        self:SetActive( not self:GetActive() )
    end
end
end

function GK7Motd:GetActive()
    return self.active
end

function GK7Motd:Open( args )
	self:SetActive( true )
end

function GK7Motd:LocalPlayerInput( args )
if self.freezeplayer then
    if self.active and Game:GetState() == GUIState.Game then
        return false
    end
end
end

function GK7Motd:SetActive( active )
    if self.active ~= active then
        if active == true and LocalPlayer:GetWorld() ~= DefaultWorld then
            Chat:Print( "You are not in the main world!", Color( 255, 0, 0 ) )
            return
        end

		if not active then
			Game:FireEvent("ply.unpause")
		end
        self.active = active
        Mouse:SetVisible( self.active )
    end
end

function GK7Motd:Render()
    local is_visible = self.active and (Game:GetState() == GUIState.Game)

    if self.window:GetVisible() ~= is_visible then
        self.window:SetVisible( is_visible )
    end

    if self.active then
        Mouse:SetVisible( true )
    end
end

function GK7Motd:Close( args )
    self:SetActive( false )
end

local gk7_motd = GK7Motd()
