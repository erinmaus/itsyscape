--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Time.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local socket = require "socket"

-- Contains time management.
local Time = {}
Time.DAY = 24 * 60 * 60
Time.BIRTHDAY_INFO = {
	year = 2018,
	month = 3,
	day = 23,
}
Time.INGAME_BIRTHDAY_INFO = {
	year = 1000,
	month = 1,
	day = 1
}
Time.INGAME_RITUAL_INFO = {
	year = 1,
	month = 2,
	day = 25,
	dayOfWeek = 2,
}
Time.BIRTHDAY_TIME = os.time(Time.BIRTHDAY_INFO)

Time.DAYS = {
	"Featherday", -- Sunday
	"Myreday",    -- Monday
	"Theoday",    -- Tuesday
	"Brakday" ,   -- Wednesday
	"Takday",     -- Thursday
	"Enderday",   -- Friday,
	"Yenderday"   -- Saturday
}

Time.AGE_BEFORE_RITUAL = "Age of Gods"
Time.AGE_AFTER_RITUAL  = "Age of Humanity"

Time.SHORT_AGE = {
	[Time.AGE_BEFORE_RITUAL] = "A.G.",
	[Time.AGE_AFTER_RITUAL]  = "A.H."
}

Time.MONTHS = {
	"Fallsun",
	"Emptorius",
	"Longnights",
	"Basturian",
	"Godsun",
	"Yohnus",
	"Emberdawn",
	"Prisius",
	"Linshine",
	"Chillbreak",
	"Fogsden",
	"Darksere",
	"Yendermonth"
}

Time.DAYS_IN_INGAME_MONTH = {
	30,
	25,
	31,
	28,
	29,
	31,
	29,
	30,
	29,
	29,
	28,
	31,
	27
}

Time.NUM_DAYS_PER_INGAME_YEAR = 377

function Time._getIngameYearMonthDay(days)
	local daysSinceRitualYear = Time.INGAME_BIRTHDAY_INFO.year * Time.NUM_DAYS_PER_INGAME_YEAR + days
	local year = math.floor(daysSinceRitualYear / Time.NUM_DAYS_PER_INGAME_YEAR)

	local day = daysSinceRitualYear - (math.floor(daysSinceRitualYear / Time.NUM_DAYS_PER_INGAME_YEAR) * Time.NUM_DAYS_PER_INGAME_YEAR) + 1
	local dayOfWeek = daysSinceRitualYear % #Time.DAYS + 1

	local month
	do
		local d = 0
		for i, daysInMonth in ipairs(Time.DAYS_IN_INGAME_MONTH) do
			if day <= d + daysInMonth then
				month = i
				break
			else
				d = d + daysInMonth
			end
		end

		day = day - d
	end

	local age
	if year <= 0 then
		year = math.abs(year) + 1
		age = Time.AGE_BEFORE_RITUAL
	else
		age = Time.AGE_AFTER_RITUAL
	end

	return {
		year = year,
		month = month,
		day = day,
		age = age,
		dayOfWeek = dayOfWeek,
		dayOfWeekName = Time.DAYS[dayOfWeek],
		monthName = Time.MONTHS[month]
	}
end

function Time.getIngameYearMonthDay(currentTime)
	local days = Time.getDays(currentTime)
	return Time._getIngameYearMonthDay(days)
end

function Time.toCurrentTime(year, month, day)
	year = year or 1
	month = month or 1
	day = day or 1

	local yearDifference = year - Time.INGAME_BIRTHDAY_INFO.year
	local offsetDays = math.abs(yearDifference) * Time.NUM_DAYS_PER_INGAME_YEAR + (day - 1)

	for i = 1, month - 1 do
		offsetDays = offsetDays + Time.DAYS_IN_INGAME_MONTH[i]
	end

	offsetDays = offsetDays * math.sign(yearDifference)

	local offsetTime = offsetDays * Time.DAY
	local currentTime = Time.BIRTHDAY_TIME + offsetTime
	return currentTime
end

-- Applies years, then months, then days.
-- Does not handle fractional years/month/days.
function Time.offsetIngameTime(currentTime, dayOffset, monthOffset, yearOffset)
	yearOffset = math.floor(yearOffset or 0)
	monthOffset = math.floor(monthOffset or 0)
	dayOffset = math.floor(dayOffset or 0)

	local yearMonthDay = Time.getIngameYearMonthDay(currentTime)

	if yearMonthDay.age == Time.AGE_BEFORE_RITUAL then
		yearMonthDay.year = -(yearMonthDay.year - 1)
	end

	yearMonthDay.year = yearMonthDay.year + yearOffset + math.floor(monthOffset / #Time.MONTHS) + math.floor(dayOffset / Time.NUM_DAYS_PER_INGAME_YEAR)

	local remainderMonths = math.sign(monthOffset) * (math.abs(monthOffset) % #Time.MONTHS)
	if monthOffset < 0 then
		if math.abs(remainderMonths) >= year.month then
			year = year - 1

			yearMonthDay.month = year.month - remainderMonths + #Time.MONTHS
		else
			yearMonthDay.month = yearMonthDay + remainderMonths
		end
	elseif monthOffset > 0 then
		yearMonthDay.month = yearMonthDay.month + remainderMonths
		if yearMonthDay.month >= #Time.MONTHS then
			yearMonthDay.month = yearMonthDay.month - #Time.MONTHS
			year = year + 1
		end
	end

	yearMonthDay.day = yearMonthDay.day + math.sign(dayOffset) * math.abs(dayOffset) % Time.NUM_DAYS_PER_INGAME_YEAR
	while yearMonthDay.day > Time.DAYS_IN_INGAME_MONTH[yearMonthDay.month] or yearMonthDay.day <= 0 do
		if yearMonthDay.day <= 0 then
			yearMonthDay.day = yearMonthDay + Time.DAYS_IN_INGAME_MONTH[yearMonthDay.month]

			yearMonthDay.month = yearMonthDay.month - 1
			if yearMonthDay.month <= 0 then
				yearMonthDay.month = #Time.MONTHS
				yearMonthDay.year = yearMonthDay.year - 1
			end
		else
			yearMonthDay.day = yearMonthDay.day - Time.DAYS_IN_INGAME_MONTH[yearMonthDay.month]

			yearMonthDay.month = yearMonthDay.month + 1
			if yearMonthDay.month > #Time.MONTHS then
				yearMonthDay.month = 1
				yearMonthDay.year = yearMonthDay.year + 1
			end
		end
	end

	do
		local daysSinceRitualYear = Time.NUM_DAYS_PER_INGAME_YEAR * yearMonthDay.year + yearMonthDay.day
		for i = 1, yearMonthDay.month - 1 do
			daysSinceRitualYear = daysSinceRitualYear + Time.DAYS_IN_INGAME_MONTH[i]
		end

		yearMonthDay.dayOfWeek = daysSinceRitualYear % #Time.DAYS + 1
		yearMonthDay.dayOfWeekName = Time.DAYS[yearMonthDay.dayOfWeek]
	end

	if yearMonthDay.year <= 0 then
		yearMonthDay.year = math.abs(yearMonthDay.year) + 1
		yearMonthDay.age = Time.AGE_BEFORE_RITUAL
	else
		yearMonthDay.age = Time.AGE_AFTER_RITUAL
	end

	yearMonthDay.monthName = Time.MONTHS[yearMonthDay.month]

	return yearMonthDay
end

function Time.getAndUpdateAdventureStartTime(root)
	local clockStorage = root:getSection("Clock")
	if not clockStorage:hasValue("start") then
		clockStorage:set("start", Time.BIRTHDAY_TIME)
	end

	return clockStorage:get("start")
end

function Time.getDays(currentTime, referenceTime)
	referenceTime = referenceTime or Time.BIRTHDAY_TIME
	currentTime = currentTime or os.time()

	return math.floor(os.difftime(currentTime, referenceTime) / Time.DAY)
end

function Time.getSeconds(root)
	return root:getSection("Clock"):get("seconds") or 0
end

function Time.getAndUpdateTime(root)
	local currentOffset = root:getSection("Clock"):get("offset") or 0
	local currentGameTime = root:getSection("Clock"):get("time") or os.time()
	local currentTime = os.time()

	if currentTime >= currentGameTime then
		root:getSection("clock"):set("time", currentTime)
	end

	local ms = math.floor((socket.gettime() % 1) * 1000)
	return currentTime + currentOffset + (ms / 1000)
end

function Time.updateTime(root, days, seconds)
	local currentOffset = root:getSection("Clock"):get("offset") or 0
	local futureOffset = currentOffset + Time.DAY * (days or 1) + (seconds or 0)
	root:getSection("Clock"):set("offset", futureOffset)

	if seconds then
		local currentSeconds = root:getSection("Clock"):get("seconds") or 0
		root:getSection("Clock"):set("seconds", currentSeconds + seconds)
	end

	return Time.getAndUpdateTime(root)
end

return Time
