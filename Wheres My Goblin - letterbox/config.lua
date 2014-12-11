application =
{

	content =
	{
		width = 768,
		height = 1024, 
		scale = "letterBox",
		fps = 30,
		
		imageSuffix =
		{
			-- ["-small"] = 0.375,
			["@2x"] = 1.5,
			-- high-resolution devices (Retina iPad, Kindle Fire HD 9", Nexus 10, etc.) will use @2x-suffixed images
            -- devices less than 1200 pixels in width (iPhone 5, iPad 2, Kindle Fire 7", etc.) will use non-suffixed images
		}
	}

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
