local Utility = require "ItsyScape.Game.Utility"

return function(peep, methods)
	local common = {}

	function common.common_calendar_get_day(day, currentTime, insideFormat, outsideFormat)
		insideFormat = insideFormat or "%day"
		outsideFormat = outsideFormat or "--"
		currentTime = currentTime or Utility.Time.BIRTHDAY_TIME

		local yearMonthDay = Utility.Time.getIngameYearMonthDay(currentTime)
		local firstDayOfMonthTime = Utility.Time.toCurrentTime(yearMonthDay.year, yearMonthDay.month, 1)
		local firstDayYearMonthDay = Utility.Time.getIngameYearMonthDay(firstDayOfMonthTime)
		local dayOfWeekOffset = 1 - (firstDayYearMonthDay.dayOfWeek + 1)
		local relativeDay = dayOfWeekOffset + day
		local maxNumDays = Utility.Time.DAYS_IN_INGAME_MONTH[month]

		local calendarYearMonthDay = Utility.Time.offsetIngameTime(firstDayOfMonthTime, relativeDay)
		local calendarTime = Utility.Time.toCurrentTime(calendarYearMonthDay.year, calendarYearMonthDay.month, calendarYearMonthDay.day)

		if calendarYearMonthDay.month ~= yearMonthDay.month then
			return methods.format_date(outsideFormat, calendarTime)
		else
			return methods.format_date(insideFormat, calendarTime)
		end
	end

	return common
end
