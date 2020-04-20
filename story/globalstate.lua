local state = {
  location = "Lab",
  part = "intro",
  wasinhouse = false,
  bottletaken = false,
  wasinkitchen = false,
  bathroom = false,
  bedroom = false,
  storageroom = false,
  livingroom = false,
  wasupstairs = false,
  inspecthousept3 = false,
  potatobar = -1,
  showtimer = false,
  watertimer = 10 -- seconds
}

function state.houseinspected()
  return state.wasinkitchen and state.wasupstairs and state.livingroom
end

return state