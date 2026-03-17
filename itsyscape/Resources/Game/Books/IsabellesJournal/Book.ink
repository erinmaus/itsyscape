INCLUDE ../Common/Common.ink

VAR default_style = "<style fontFamily:string='Serif/Regular' fontSize:number='3' align:string='left' color:string='000000' />"

== spine_title ==
<style fontFamily='Serif/Bold' fontSize='10' align='center' />
<text x='50' y='50' rotation='90' originX='50' originY='50' color:string='ffd42a'>Isabelle</text>
-> DONE

== front_cover_title ==
<style fontFamily='Serif/Bold' fontSize='10' align='center' />
<text x='0' y='12' width='95' color:string='000000'>Isabelle</text>
-> DONE

== calendar_page(current_time, month) ==
~ temp year = ir_get_date_component(current_time, "year")
~ temp calendar_time = ir_to_current_time(year, month, 1)
~ temp is_long_calendar = ir_common_calendar_get_day(29, calendar_time) != "--"
~ temp format = "%monthName, %year %age"

{default_style}

{ir_format_date("%monthName\, %year %age", calendar_time)}

<style align='center' />
<text x='10' y='20' width='10'>F</text>
<text x='20' y='20' width='10'>M</text>
<text x='30' y='20' width='10'>T</text>
<text x='40' y='20' width='10'>T</text>
<text x='50' y='20' width='10'>W</text>
<text x='60' y='20' width='10'>E</text>
<text x='70' y='20' width='10'>Y</text>

<text x='10' y='25' width='10'>{ir_common_calendar_get_day(1, calendar_time)}</text>
<text x='20' y='25' width='10'>{ir_common_calendar_get_day(2, calendar_time)}</text>
<text x='30' y='25' width='10'>{ir_common_calendar_get_day(3, calendar_time)}</text>
<text x='40' y='25' width='10'>{ir_common_calendar_get_day(4, calendar_time)}</text>
<text x='50' y='25' width='10'>{ir_common_calendar_get_day(5, calendar_time)}</text>
<text x='60' y='25' width='10'>{ir_common_calendar_get_day(6, calendar_time)}</text>
<text x='70' y='25' width='10'>{ir_common_calendar_get_day(7, calendar_time)}</text>

<text x='10' y='30' width='10'>{ir_common_calendar_get_day(8, calendar_time)}</text>
<text x='20' y='30' width='10'>{ir_common_calendar_get_day(9, calendar_time)}</text>
<text x='30' y='30' width='10'>{ir_common_calendar_get_day(10, calendar_time)}</text>
<text x='40' y='30' width='10'>{ir_common_calendar_get_day(11, calendar_time)}</text>
<text x='50' y='30' width='10'>{ir_common_calendar_get_day(12, calendar_time)}</text>
<text x='60' y='30' width='10'>{ir_common_calendar_get_day(13, calendar_time)}</text>
<text x='70' y='30' width='10'>{ir_common_calendar_get_day(14, calendar_time)}</text>

<text x='10' y='35' width='10'>{ir_common_calendar_get_day(15, calendar_time)}</text>
<text x='20' y='35' width='10'>{ir_common_calendar_get_day(16, calendar_time)}</text>
<text x='30' y='35' width='10'>{ir_common_calendar_get_day(17, calendar_time)}</text>
<text x='40' y='35' width='10'>{ir_common_calendar_get_day(18, calendar_time)}</text>
<text x='50' y='35' width='10'>{ir_common_calendar_get_day(19, calendar_time)}</text>
<text x='60' y='35' width='10'>{ir_common_calendar_get_day(20, calendar_time)}</text>
<text x='70' y='35' width='10'>{ir_common_calendar_get_day(21, calendar_time)}</text>

<text x='10' y='40' width='10'>{ir_common_calendar_get_day(22, calendar_time)}</text>
<text x='20' y='40' width='10'>{ir_common_calendar_get_day(23, calendar_time)}</text>
<text x='30' y='40' width='10'>{ir_common_calendar_get_day(24, calendar_time)}</text>
<text x='40' y='40' width='10'>{ir_common_calendar_get_day(25, calendar_time)}</text>
<text x='50' y='40' width='10'>{ir_common_calendar_get_day(26, calendar_time)}</text>
<text x='60' y='40' width='10'>{ir_common_calendar_get_day(27, calendar_time)}</text>
<text x='70' y='40' width='10'>{ir_common_calendar_get_day(28, calendar_time)}</text>

{ is_long_calendar: <text x='10' y='45' width='10'>{ir_common_calendar_get_day(29, calendar_time)}</text> }
{ is_long_calendar: <text x='20' y='45' width='10'>{ir_common_calendar_get_day(30, calendar_time)}</text> }
{ is_long_calendar: <text x='30' y='45' width='10'>{ir_common_calendar_get_day(31, calendar_time)}</text> }
{ is_long_calendar: <text x='40' y='45' width='10'>{ir_common_calendar_get_day(32, calendar_time)}</text> }
{ is_long_calendar: <text x='50' y='45' width='10'>{ir_common_calendar_get_day(33, calendar_time)}</text> }
{ is_long_calendar: <text x='60' y='45' width='10'>{ir_common_calendar_get_day(34, calendar_time)}</text> }
{ is_long_calendar: <text x='70' y='45' width='10'>{ir_common_calendar_get_day(35, calendar_time)}</text> }

-> DONE

== page_1 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 1)
-> DONE

== page_2 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 2)
-> DONE

== page_3 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 3)
-> DONE

== page_4 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 4)
-> DONE

== page_5 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 5)
-> DONE

== page_6 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 6)
-> DONE

== page_7 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 7)
-> DONE

== page_8 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 8)
-> DONE

== page_9 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 9)
-> DONE

== page_10 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 10)
-> DONE

== page_11 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 11)
-> DONE

== page_12 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 12)
-> DONE

== page_13 ==
~ temp current_time = ir_get_current_time()
-> calendar_page(current_time, 13)
-> DONE
