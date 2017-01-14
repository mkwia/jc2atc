--
-- Pretty much anything not part of the HUD class or cMathFunctions.lua goes in here.
--


globals = {}
local G = globals

G.printCount = 0

--
-- Create the core of the script.
--
Events:Subscribe(
	"ModuleLoad" ,
	function()
		local hud = HUD()
	end
)

--
-- Register with help menu.
--
--function AddToHelp()
	
	-- Add us to the help menu.
--	local args = {}
--	args.name = settings.name
--	args.text = settings.description
--	Events:Fire("HelpAddItem" , args)
	
--end

--function RemoveFromHelp()
	
	-- Remove us from the help menu.
--	local args = {}
--	args.name = settings.name
--	Events:Fire("HelpRemoveItem" , args)
	
--end

--Events:Subscribe("ModulesLoad" , AddToHelp)
--Events:Subscribe("ModuleUnload" , RemoveFromHelp)