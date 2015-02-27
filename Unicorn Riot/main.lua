-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

---

local totalDays = 365
local currentDay = 0
local timePerDay = 12
local timeSpent = 0
local activityCount = 0

local player = {}
player.money = 0
player.skill = 0

local activity = {}

activity.current = "none"

activity.dayJob = {}
activity.dayJob.time = 4
activity.dayJob.money = 8
activity.dayJob.skill = 0

activity.bandPractice = {}
activity.bandPractice.time = 2
activity.bandPractice.money = 0
activity.bandPractice.skill = 2

local function newDay()
	currentDay = currentDay + 1
	timeSpent = 0
	activityCount = 0
	print("----")
	print("Today is day " .. currentDay .. ".")
	print("The battle of the bands starts in " .. totalDays - currentDay .. " days.")
	print("You have $" .. player.money .. ".")
	print("You have " .. player.skill .. " skill pts.")
end

local function endOfDay()
	print("Day " .. currentDay .. " has ended.")
	newDay()
end

local function activityComplete()
	print("Activity complete.")
	if( timeSpent >= timePerDay ) then
		endOfDay()
	end
end

--[[
local function startActivity( name )
	activityCount = activityCount + 1
	print("* Starting activity " .. activityCount .. ": " .. name)
	local time = activity.name.time
	local money = activity.name.money
	local skill = activity.name.skill
	timeSpent = timeSpent + time
	player.money = player.money + money
	player.skill = player.skill + skill 
	print("(Time -" .. time .. ", Money +" .. money .. ", Skill +" .. skill ..")")
	print("Time spent today: " .. timeSpent .. "hrs.")
	print("Total Money: $" .. player.money)
	print("Total skill: " .. player.skill)
	activityComplete()
end
]]--

local function startDayJob()
	activityCount = activityCount + 1
	print("* Starting activity " .. activityCount .. ": Day Job")
	local time = 4
	local money = 8
	timeSpent = timeSpent + time
	player.money = player.money + money 
	print("(Time -" .. time .. ", Money +" .. money .. ")")
	print("Time spent today: " .. timeSpent .. "hrs.")
	print("Total Money: $" .. player.money)
	activityComplete()
end

local function startBandPractice()
	activityCount = activityCount + 1
	print("* Starting activity " .. activityCount .. ": Band Practice")
	local time = 2
	local skill = 3
	timeSpent = timeSpent +time
	player.skill = player.skill + skill 
	print("(Time -" .. time .. ", Skill +" .. skill ..")")
	print("Time spent today: " .. timeSpent .. "hrs.")
	print("Total skill: " .. player.skill)
	activityComplete()
end

local function startSoloPractice()
	activityCount = activityCount + 1
	print("* Starting activity " .. activityCount .. ": Solo Practice")
	local time = 1
	local skill = 1
	timeSpent = timeSpent +time
	player.skill = player.skill + skill 
	print("(Time -" .. time .. ", Skill +" .. skill ..")")
	print("Time spent today: " .. timeSpent .. "hrs.")
	print("Total skill: " .. player.skill)
	activityComplete()
end

local activityBtn = display.newText( "Perform Activity", cX, 50, native.systemFont, 30 )
activityBtn:addEventListener( "tap", activityComplete )

local dayJobBtn = display.newText( "Day Job", cX, 100, native.systemFont, 30 )
dayJobBtn:addEventListener( "tap", startDayJob )

local bandPracticeBtn = display.newText( "Band Practice", cX, 150, native.systemFont, 30 )
bandPracticeBtn:addEventListener( "tap", startBandPractice )

local soloPracticeBtn = display.newText( "Solo Practice", cX, 200, native.systemFont, 30 )
soloPracticeBtn:addEventListener( "tap", startSoloPractice )

-- start gameStart

newDay()