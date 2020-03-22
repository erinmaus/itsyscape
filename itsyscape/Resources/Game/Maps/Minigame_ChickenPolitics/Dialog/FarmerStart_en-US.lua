TARGET_NAME = _TARGET:getName()

local mapScript = Utility.Peep.getMapScript(_TARGET)
if mapScript.isDone then
	speaker "Farmer"
	message "Thank ya for knockin' some sense into 'em chickens."
	return
elseif mapScript.hasStarted then
	speaker "Farmer"
	message "Tackle 'em chickens, %person{${TARGET_NAME}}!"
	return
end

speaker "_TARGET"
message "Let's do this!"
mapScript:poke('start')
