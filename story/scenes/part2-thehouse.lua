local b = require("ui.button")
local gstate = require("story.globalstate")
local sequence = require("story.branch.sequence")

local scene = {}
local runner = nil

local AGENT_NAME = "Agent Brook Swatson"

local SCENES = {}

local function hallwayafterkitchen()
  local livingroom = SCENES.livingroomscene()
  local upstairs = SCENES.upstairsscene()
  
  local observe = sequence.create(nil, {
    "That smell... reminds me of my old grandma's house",
    "You try to remember how your grandma look like but it's not important right now"
  }, nil, {}, function ()
    gstate.wasinkitchen = true
  end)

  if not gstate.livingroom then
    observe.actionlist["Go to the living room"] = livingroom
  end

  if not gstate.wasupstairs then
    observe.actionlist["Go upstairs"] = upstairs
  end

  return observe
end

local function kitchenscene()
  local hallwayscene = hallwayafterkitchen()
  
  local nothingelse = sequence.create(nil, {
    "It seems that there is nothing more even slightly interesting in the kitchen",
    "So you decide to go back to the hallway"
  }, hallwayscene)
  
  local fridgelook = sequence.create(nil, {
    "You look around more, trying to find something interesting or maybe useful",
    "There is a fridge",
    "You walk to the fridge. Open it. It's pretty cold inside. There might be electicity available",
    "Inside the fridge you see nothing except a test tube",
    "You wonder why is it here and what in it. But you guess it's a job for the chemistry scientists, not you",
    "One of your nerd friends who knows chemistry very well work with you",
    "But right now is not the time to call him. You did not forget about the main object of interest"
  }, nothingelse)
  
  local kitchenlook2 = sequence.create(nil, {
    "You are still standing in the kitchen"
  }, nil, {
    ["Look around more"] = fridgelook,
    ["Go back to the hallway"] = "hallway"
  })
  
  local washhands = sequence.create(nil, {
    "The water is cold but you wash your hands",
    "After finishing washing your hands you realize that...",
    "There is no towel",
    "How silly of you. Who would've thought about bringing a towel with yourself in an abandoned house",
    "You begin to dry your hands with your jacket",
    "Well... that was pretty pointless"
  }, kitchenlook2)
  
  local sinklook1 = sequence.create(nil, {
    "You also see a sink",
    "A very ordinary sink",
    "You touch the faucet. The water starts to flow",
    'You think yourself "at least i can wash my hands, right?"'
  }, nil, {
    ["Wash your hands"] = washhands,
    ["That'd be silly. Go back"] = kitchenlook2
  })
  
  local kitchenlook1 = sequence.create(nil, {
    "You are standing in the kitchen"
  }, nil, {
    ["Look around more"] = sinklook1,
    ["Go back to the hallway"] = "hallway"
  })
  
  local touchknobs = sequence.create(nil, {
    "You are trying to rotate the knobs. They sit pretty tight. But still...",
    "Nothing happens and you go back from the stove"
  }, kitchenlook1)
  
  local stoveknobs = sequence.create(nil, {
    "You look at the knobs"
  }, nil, {
    ["Touch the knobs"] = touchknobs,
    ["Go back"] = kitchenlook1
  })
  
  local establishloc = sequence.create(nil, {
    "You walk into the kitchen",
    "Everything here looks as old as in the entire house. But this room is pretty tidied up, dust aside",
    "You don't think that there can be something interesting to look at",
    "But some things do look like they are slightly out of place",
    "You notice a stove with knobs turned on all way up. But there is no gas smell or anything",
    "You guess that the stove has gas control system so it wont blow up randomly"
  }, nil, {
    ["Look at the knobs"] = stoveknobs,
    ["Go back"] = kitchenlook1
  })

  return establishloc
end

function SCENES.livingroomscene()
  local state = {}
  
  local bottletake = sequence.create(nil, {
    "You take the bottle from the cabinet. *click* You hear the noise",
    "Thinking it was the cabinet struggling holding that much of bottles you decide to leave the bottle on the floor"
  }, "livingroom", nil, function ()
    state.washere = true
    state.cabinet = true
    
    sequence.changelookupitem(
      runner, 
      "livingroom", 
      state.gen()
    )

    gstate.bottletaken = true
  end)
  
  local cabinet = sequence.create(nil, {
    "There are many bottles with an alcohol",
    "You think it is, because they all look pretty, like bottles in a liquor store",
    "There is a bottle with a pretty worn out label"
  }, nil, {
    ["Take it and have a closer look"] = bottletake,
    ["Continue to the living room"] = "livingroom"
  })
  
  local fireplace = sequence.create(nil, {
    "You look at the fireplace but there is no fire. Or...",
    "There is a note inside. You take it and have a look at it",
    "It's some gibberish, symbols, shapes, words. Clean, inject, shutdown? You don't know what that mean but you take the note with yourself"
  }, "livingroom", nil, function ()
    state.washere = true
    state.fireplace = true
    
    sequence.changelookupitem(
      runner, 
      "livingroom", 
      state.gen()
    )
  end)
  
  local tvlook = sequence.create(nil, {
    "The TV is covered in thick layer of dust as everything in this house",
    "You turn it on. It starts to warm up and...",
    "You see nothing but the static. Well, you tried your best and it's not the time to watch news"
  }, "livingroom", nil, function ()
    state.washere = true
    state.tv = true
    
    sequence.changelookupitem(
      runner, 
      "livingroom", 
      state.gen()
    )
  end)

  state.gen = function ()
    local text = {}
  
    if state.washere then
      text = {
        "There are a big old tube TV, a fireplace and a cabinet full of bottles"
      }
    else
      text = {
        "You walk into the living room",
        "Firstly you notice that every piece of furniture is under a blanket",
        "Not asking youself any questions you look around more",
        "There are a big old tube TV, a fireplace and a cabinet full of bottles"
      }
    end

    local actions = {}

    if not state.tv then
      actions["Look at the TV"] = tvlook
    end

    if not state.fireplace then
      actions["Look at the fireplace"] = fireplace
    end

    if not state.cabinet then
      actions["Look at the cabinet"] = cabinet
    end

    local continuewith = nil

    if state.washere and state.tv and state.fireplace and state.cabinet then
      text = {
        "You go back to the room entrance to explore missing things but there is nothing else interesting in this room",
        "You decide to go back to the hallway"
      }
      actions = nil
      gstate.livingroom = true
      continuewith = SCENES.hallwayscene()
    end

    return sequence.create(nil, text, continuewith, actions, nil, "livingroom")
  end
  
  local walkin = state.gen()

  return walkin
end

local function bathroomscene()
  local state = {
    sink = false,
    cabinet = false,
    bathtub = false,
    toilet = false,
    washingmachine = false
  }

  --- WASHING MACHINE

  local washingmachine = sequence.create(nil, {
    "A washing machine. Pretty old one you guess",
    "You open it and start rotating a washing drum for some reason",
    "It does rotate but something is clinging to it in the bottom",
    "You see a little door on the bottom on the washing machine. You guess it's a door where you can take out your keys from a pants so they will not flush away",
    "You open the door and see a key. Damn, you are good at this"
  }, "bathroom", nil, function ()
    state.washingmachine = true
    state.genbathroom()
  end)

  --- TOILET

  local toilet = sequence.create(nil, {
    "Nothing exceptional about this toilet",
    "You wonder if it flushes backwards as if it was in Australia. But that would be just silly"
  }, "bathroom", nil, function ()
    state.toilet = true
    state.genbathroom()
  end)

  --- BATHTUB

  local bathtub = sequence.create(nil, {
    "Just a bathtub. You have one in your home"
  }, "bathroom", nil, function ()
    state.bathtub = true
    state.genbathroom()
  end)

  --- CABINET

  local cabinet = sequence.create(nil, {
    "You open the medicine cabinet",
    "There is nothing except a strange white jar of liquid",
    "You just take it without thinking because you got distracted by thoughts about the bathtub"
  }, "bathroom", nil, function ()
    state.cabinet = true
    state.genbathroom()
  end)

  --- SINK

  local sinktext = {}
  local sinkactions = {}
  local sinkcontinue = nil

  if gstate.wasinkitchen then
    sinktext = {
      "An ordinary sink. You remember there is water available"
    }
    sinkactions = nil
    sinkcontinue = "bathroom"
  else
    sinktext = {
      "An ordinary sink. You wonder if there is water available",
      "You turn on the faucet and see water running",
      "As if you wanted to wash your hands..."
    }
    sinkactions = {
      ["Wash your hands?"] = sequence.create(nil, {
        "You just washed your hands. They are clean but... there is no towel",
        "You are not very happy of choice you've made but there is nothing you can do now",
        "You proceed to dry your hands with your jacket"
      }, "bathroom", nil, function ()
        state.sink = true
        state.genbathroom()
      end),
      ["Let's continue the job"] = "bathroom"
    }
  end

  local sink = sequence.create(nil, sinktext, sinkcontinue, sinkactions, function ()
    state.sink = true
    state.genbathroom()
  end)

  --- ENTER

  function state.genbathroom()
    if state.sink and state.cabinet and state.bathtub and state.toilet and state.washingmachine then
      gstate.bathroom = true
      
      SCENES.upstairsscene()

      sequence.changelookupitem(runner, "bathroom", sequence.create(nil, {
        "You think you've got it all"
      }, "upstairs"))
      
      return
    end

    local actions = {}

    if not state.sink then
      actions["Look at the sink"] = sink
    end

    if not state.cabinet then
      actions["Look in the medicine cabinet"] = cabinet
    end

    if not state.bathtub then
      actions["Look at the bathtub"] = bathtub
    end

    if not state.toilet then
      actions["Look at the toilet"] = toilet
    end

    if not state.washingmachine then
      actions["Look at the washing machine"] = washingmachine
    end

    sequence.changelookupitem(runner, "bathroom", sequence.create(nil, {
      "There are a lot options you can do"
    }, nil, actions, nil, "bathroom"))
  end
  
  local enter = sequence.create(nil, {
    "You walk into the bathroom. I hope you don't wanna pee or something",
    "You see a sink, a medicine cabinet above, a bathtub, a toilet and a washing machine",
    "You know that separate bathrooms are more convenient than combined. But that's off-topic",
    "There are a lot options you can do"
  }, nil, {
    ["Look at the sink"] = sink,
    ["Look in the medicine cabinet"] = cabinet,
    ["Look at the bathtub"] = bathtub,
    ["Look at the toilet"] = toilet,
    ["Look at the washing machine"] = washingmachine
  }, nil, "bathroom")

  return enter
end

function SCENES.upstairsscene()
  local state = {
    wardrobe = false,
    window = false,
    bed = false
  }

  --- BEDROOM
  
  local wardrobe = sequence.create(nil, {
    "You go to wardrobe. Maybe at least here you'll find something interesting",
    "But that grandma smell interrupts your thoughts",
    "You open the door and see many clothes in front of you. But there is something else",
    "You look down and gasp. You try to back off a little to see it to scale",
    "There is a dead body lying on the wardrobe's floor",
    "Isn't the police was here? Remembering how lazy police officers can be you stop thinking about the police",
    "Well. That was a shoker. But you've seen worse",
    "Maybe you should talk about the body to Brook. In the end it's his job... kind of"
  }, "bedroom", nil, function ()
    state.wardrobe = true
    state.genfinished()
  end)
  
  local window = sequence.create(nil, {
    "You look at the window",
    "Nothing unordinary here. Just a window with a view on the neighborhood",
    "You think it's a pretty nice view. Then you notice a backyard",
    '"There is something not right" you think. But it\'s just a backyard... with a bunker door in it',
    "You don't even ask yourself why the owner of the house built the bunker or maybe someone built it before the current owner of the house",
    "Who knows. One thing you notice is that the bunker door seems to be locked"
  }, "bedroom", nil, function ()
    state.window = true
    state.genfinished()
  end)
  
  local bed = sequence.create(nil, {
    "You go to the bed to see that it's just a bed... with foodstains on it?",
    "You notice that furniture here is not covered in blankets. But that's not so important",
    "You imagine who would live in this house and who whould eat on its bed",
    'You are furious in your head. "there is a kitchen! why eat on your own bed and not even wash bed sheets after". Pig!',
    "Calming yourself down you remember why you are here. Definitely not to think about some guy eating in his own bed. Why even bother?"
  }, "bedroom", nil, function ()
    state.bed = true
    state.genfinished()
  end)

  function state.genfinished()
    if state.wardrobe and state.window and state.bed then
      gstate.bedroom = true
      sequence.changelookupitem(runner, "bedroom", sequence.create(nil, {
        "You've seen enough. At least in this room. There are more rooms on the floor"
      }, "upstairs"))
      state.genseq()
    else
      local actions = {}

      if not state.wardrobe then
        actions["Go check the wardrobe"] = wardrobe
      end

      if not state.window then
        actions["Go check the window"] = window
      end

      if not state.bed then
        actions["Go check the bed"] = bed
      end
      
      sequence.changelookupitem(runner, "bedroom", sequence.create(nil, {
        "In bedroom there is a bed, a window and a wardrobe"
      }, nil, actions))
    end
  end
  
  local bedroom = sequence.create(nil, {
    "You walk in the bedroom",
    "Yes, this is a bedroom as you thought. And you wonder what you can find in here. Maybe something private?",
    "You see nothing but a typical set of things as if it was your own bedroom",
    "Also there is a wardrobe in the wall and a window"
  }, nil, {
    ["Go check the bed"] = bed,
    ["Go check the window"] = window,
    ["Go check the wardrobe"] = wardrobe
  }, nil, "bedroom")
  
  --- STORAGEROOM

  local storageroom = sequence.create(nil, {
    "You look inside the storage room. You can't get into it because there are tons of garbage electronics here",
    "Looking at the garbage you feel pretty bored in front of this room"
  }, "upstairs", nil, function ()
    gstate.storageroom = true
    state.genseq()
  end)

  --- ENTER

  local bathroom = bathroomscene()

  function state.genseq()
    if gstate.bathroom and gstate.bedroom and gstate.storageroom then
      gstate.wasupstairs = true
      local upstairs = SCENES.hallwayscene()
      print("upstairs genseq")
      
      return sequence.changelookupitem(runner, "upstairs", sequence.create(nil, {
        "Let's go downstairs"
      }, upstairs))
    else
      local actions = {}

      if not gstate.bathroom then
        actions["Go to the bathroom"] = bathroom
      end

      if not gstate.storageroom then
        actions["Go inside a room that looks like a storage room"] = storageroom
      end

      if not gstate.bedroom then
        actions["Go inside a room that looks like bedroom"] = bedroom
      end
      
      return sequence.changelookupitem(runner, "upstairs", sequence.create(nil, {
        "There a couple of rooms and a bathroom"
      }, nil, actions))
    end
  end

  if gstate.bathroom or gstate.bedroom or gstate.storageroom then
    return state.genseq()
  else
    return sequence.create(nil, {
      "You take a deep breath and start walking up the stairs",
      "You are not that young boy who jumps around, runs up and down the stairs all day long with the friends",
      "At the top of the stairs you see a small hallway",
      "There a couple of rooms and a bathroom",
      "You wonder why there is no bathroom on the first floor. Or maybe you just didn't see it"
    }, nil, {
      ["Go inside a room that looks like bedroom"] = bedroom,
      ["Go inside a room that looks like a storage room"] = storageroom,
      ["Go to the bathroom"] = bathroom
    }, nil, "upstairs")
  end
end

local hallwaystate = nil

function SCENES.hallwayscene()
  print("halwauy")

  if not hallwaystate then
    hallwaystate = {
      kitchen = kitchenscene(),
      livingroom = SCENES.livingroomscene(),
      upstairs = SCENES.upstairsscene()
    }
  end

  if gstate.wasupstairs and gstate.wasinkitchen and gstate.livingroom then
    return sequence.create(nil, {
      "You have discovered all the rooms and now can go to the... here is Brook"
    }, sequence.create(AGENT_NAME, {
      "Hey. Are you done with your investigation mr house inspector. Ha-ha-ha."
    }, sequence.create(nil, {
      "You don't really understand the humor. Just don't mind it"
    }, sequence.create(AGENT_NAME, {
      "Alright. Let's go to the basement"
    }, sequence.create(nil, {
      "You and your partner are going to the basement. And why does all cool things happen in our darkest rooms"
    }, nil, nil, function ()
      if scene.transitioncallback then
        scene.transitioncallback()
      end
    end)))))
  end
  
  local standinghallway = sequence.create(nil, {
    "From your position it looks like there are kitchen on your left and a living room on the right. In front of you is the stairs"
  }, nil, {}, nil, "hallway")

  if not gstate.wasinkitchen then
    standinghallway.actionlist["Go to the kitchen"] = hallwaystate.kitchen
  end

  if not gstate.livingroom then
    standinghallway.actionlist["Go to the living room"] = hallwaystate.livingroom
  end

  if not gstate.wasupstairs then
    standinghallway.actionlist["Go upstairs"] = hallwaystate.upstairs
  end

  return standinghallway
end

local function setupscene()
  local hallway = SCENES.hallwayscene()

  local lookaround = sequence.create(nil, {
    "You see old walls, old furniture and clothes. Guessing that the owner wanted to leave the house fast",
    "Everything looks very fragile and under a heavy layer of dust",
    "You notice on the first floor there are two rooms and stairs going to a second floor"
  }, hallway)

  local lookaroundstart = sequence.create(AGENT_NAME, {
    "Okay. I'll wait you there in the basement."
  }, nil, {
    ["Look around yourself"] = lookaround
  })

  local scenetranstopart3 = sequence.create(AGENT_NAME, {
    "Alright. Let's go. It's in the basement."
  }, nil, nil, function ()
    if scene.transitioncallback then
      scene.transitioncallback()
    end
  end)
  
  local agentquestion = sequence.create(AGENT_NAME, {
    "Oh yeah. Do you need time to look around? Or should we go right now to those things?"
  }, nil, {
    ["Let's go to the stuff"] = scenetranstopart3,
    ["I want to look around"] = lookaroundstart
  })
  
  local walkintohouse = sequence.create(nil, {
    "You and Brook walk into the house"
  }, agentquestion)
  
  local agentstart = sequence.create(AGENT_NAME, {
    "Hello, Cave. It's good to see you again!",
    "As you see - a typical house. Let's get in."
  }, nil, {
    ["Get into the house"] = walkintohouse
  })
  
  local establishloc = sequence.create(nil, {
    "[At the house location]"
  }, agentstart)

  return establishloc
end

function scene:load(callback)
  scene.transitioncallback = callback
  
  b.loadassets()
  sequence.loadassets()

  gstate.location = "House"
  gstate.part = "house"

  if gstate.inspecthousept3 then
    runner = sequence.run(SCENES.hallwayscene())
  else
    runner = sequence.run(setupscene())
  end
end

function scene:draw()
  love.graphics.setBackgroundColor(138 / 255, 116 / 255, 106 / 255)
  
  runner:draw()

  love.graphics.setColor(250 / 255, 248 / 255, 236 / 255)
	love.graphics.print("Location: " .. gstate.location, 32, love.graphics.getHeight() - 72)
end

function scene:mouseclick(x, y, button)
	if button == 1 then
    if not sequence.handleclick(runner, x, y) then
      sequence.next(runner)
    end
	end
end

return scene