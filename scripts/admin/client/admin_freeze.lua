frozenWhiteList =
	{
		[ 3 ] = true,
		[ 4 ] = true,
		[ 5 ] = true,
		[ 6 ] = true
	}

function disableControls ( args )
	if ( not frozenWhiteList [ args.input ] ) then
		return false
	end
end

Network:Subscribe ( "freeze.setStatus",
	function ( state )
		if ( not state and freezeEvent ) then
			Events:Unsubscribe ( freezeEvent )
		elseif ( state ) then
			freezeEvent = Events:Subscribe ( "LocalPlayerInput", disableControls )
		end
	end
)