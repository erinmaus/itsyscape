TARGET_NAME = _TARGET:getName()

local mapScript = Utility.Peep.getMapResourceScript(_TARGET)
if mapScript.hasStarted then
	speaker "Farmer"
	message "Tackle 'em chickens, %person{${TARGET_NAME}}!"
	return
end

speaker "_TARGET"
message "Let's do this!"
mapScript:poke('start')
