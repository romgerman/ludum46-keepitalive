local b = require("ui.button")
local timer = require("ui.timer")
local gstate = require("story.globalstate")
local sequence = require("story.branch.sequence")

local scene = {}
local runner = nil
local gtimer = nil

local AGENT_NAME = "Agent Brook Swatson"

local stupidendpanel = sequence.create(nil, {
  "- THE END -",
  "I hope you've enjoyed my small game. At least i've finished it... without sounds and music though",
  "I guess i can count this as my first finished project",
  "There is also should be a part about mutated potato in the sewers where you control the sewer system with help of Brook to take the potato-thingy outside and study it",
  "Also there should be puzzles and stuff but i fucked that up",
  "Anyway. Thank you",
  "Now you can quit the game"
})

local function badend_drowned()
  return sequence.create(nil, {
    "The potato... Or the thing has drowned in the water",
    "At least you tried",
    "And also this is a bad ending. It sucks because i don't have any more time to think about it. Need to fix the bugs"
  }, stupidendpanel)
end

local function badend_shutdown()
  return sequence.create(nil, {
    "You was very curious what the shutdown command does",
    "The chamber hissing... opening",
    "The potato thing is laying on the table",
    "You are not sure if you want to touch it",
    "But still manages to take it into the hand",
    "It's... you know that feeling",
    "It feels like you are holding... a potato",
    "Yes. Nothing more. Just slightly warm potato in your hand",
    "Not sure if you are very satisfied with this but this is..."
  }, stupidendpanel)
end

local function goodend()  
  local finalwords = sequence.create(AGENT_NAME, {
    "Yeah. I'll be here in five minutes. Don't go anywhere. I'll drive you to the research center and if you don't wanna tell me your secrets about the potato or whatever, it's alright. I guess your science friends will understand you"
  }, stupidendpanel)
  
  local strange = sequence.create(nil, {
    "You are not moving. Staring into the abyss"
  }, finalwords)
  
  local well = sequence.create(AGENT_NAME, {
    "Alright, alright. Don't tell me what happend. I'll be here in five minutes. Gotta say to the police that everything else is alright"
  }, strange)
  
  local silencex2 = sequence.create(nil, {
    "You are still looking at the chamber"
  }, well)
  
  local about = sequence.create(AGENT_NAME, {
    "Hey... Did something gone wrong? Bah. That can't be. You are the best scientinst in the town and also my friend"
  }, silencex2)
  
  local silence = sequence.create(nil, {
    "You are silent"
  }, about)
  
  local aboutpotato = sequence.create(AGENT_NAME, {
    "Where is that potato thing?"
  }, silence)
  
  local look = sequence.create(nil, {
    "Agent looks at the glass dome. It's empty"
  }, aboutpotato)
  
  local question = sequence.create(AGENT_NAME, {
    "Did something happen? Is there something wrong here, Cave?"
  }, look)
  
  local sit = sequence.create(nil, {
    "Agent steps in. You sit in sweat with a scare on your face"
  }, question)
  
  local enter = sequence.create(AGENT_NAME, {
    "Hey, we took away the corpse. It's all good. What about you?"
  }, sit)

  return enter
end

local function finallyalivescene()
  -- NOTE: can't make the sewers part. it becomes too long to make

  local ending = goodend()
  
  local eject = sequence.create(nil, {
    "You don't know what does it mean. Eject...",
    "Will it open the chamber?",
    "Will it release that thing into the outer space?",
    "You enter the command. You can only wonder and see",
    'A message on screen says: "Ejecting... Thank you for participating"',
    "At the blink of an eye the thing is gone",
    "You are still stunned from that loud blasting sound. There is a loud squeaking sound in your ears",
    "When you recovered from that sound, you start searching for the thing",
    "It could't just dissapear",
    "But it's gone",
    "It's not in the basement",
    "It's not even inside the house",
    "The computer screen goes out",
    "Silence. You only hear... footsteps?"
  }, ending, nil, function ()
    gstate.potatobar = -1
  end)
  
  local shutdown = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "Sequence is not finished. Proceed force shutdown?"'
  }, nil, {
    ["y"] = badend_shutdown(),
    ["n"] = sequence.create(nil, {
      "You decided to not shutdown it right now"
    }, "final_actions")
  })
  
  ---
  
  local enter = sequence.create(nil, {
    "You are staring at the thing. It seems you not bothering it",
    "Amazing. How from a vegetable. From a simple potato. Came to live that strange organism",
    "Is it intelligent? Maybe. But now right now you guess. As it was born just now.",
    "You move your glance on the computer screen",
    "You still don't know what \"shutdown\" command does"
  }, nil, {
    ["eject"] = eject,
    ["shutdown"] = shutdown
  }, nil, "final_actions")

  return enter
end

local function convertionscene()
  local finallyalive = finallyalivescene()
  
  local convert = sequence.create(nil, {
    "You enter the command",
    'You are very... excited? The word "transformation" instead of "convert" has captured your mind',
    'You can\'t think about anything but "transformation"',
    'A message on screen says: "Preparing..."',
    "You think that now after all your years of learning science you can finally see something that you don't know... and maybe no one knows",
    'A message on screen says: "Warming up incubator"',
    "Finally you can get what you wanted all those years",
    "... forbidden knowlege? Nobel Prize? We will never know. But you do know",
    "Green lights in the glass dome started glow bright yellow",
    "You are feeling it. The warmth. Presence of something you've never saw",
    "Cracking noise interrupt your thoughts",
    "You are staring at the potato-thing",
    "You see it starts moving",
    "You are amazed and disgusted at the same time",
    "A minute passes...",
    "And you see it",
    "It looks like a little baby alien. At least you call it that in your head. You can't describe it. No one ever saw anything like this thing",
    "You are starting to feel warmth even more",
    "And a beep. A loud one",
    "You got scared by a computer beep",
    'A message on screen says: "Transformation completed... Type "eject" to finish sequence"'
  }, finallyalive)

  local eject = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "ERROR: Cannot eject unprepared object"'
  }, "convert_actions")

  local shutdown = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "Sequence is not finished. Proceed force shutdown?"'
  }, nil, {
    ["y"] = badend_shutdown(),
    ["n"] = sequence.create(nil, {
      "You decided to not shutdown it right now"
    }, "convert_actions")
  })
  
  ---
  
  local enter = sequence.create(nil, {
    "There is not much commands left"
  }, nil, {
    ["convert"] = convert,
    ["eject"] = eject,
    ["shutdown"] = shutdown
  }, nil, "convert_actions")

  return enter
end

local function cleanscene()
  local convertion = convertionscene()
  
  local clean = sequence.create(nil, {
    "You enter the command",
    "You are very confused and a little thrilled",
    "In all your years in science lab you didn't see anything like this before",
    'A message on screen says: "Preparing..."',
    "You feel vibrations",
    'A message on screen says: "Cleaning the chamber... Wait several seconds..."',
    "You hear sucking and clicking noises. Like a vacuum cleaner",
    'A message on screen says: "Operation completed. Object prepared for transformation"'
  }, convertion)

  local convert = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "ERROR: Not all steps finished"'
  })

  local eject = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "ERROR: Cannot eject unprepared object"'
  }, "clean_actions")

  local shutdown = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "Sequence is not finished. Proceed force shutdown?"'
  }, nil, {
    ["y"] = badend_shutdown(),
    ["n"] = sequence.create(nil, {
      "You decided to not shutdown it right now"
    }, "clean_actions")
  })

  ---

  local enter = sequence.create(nil, {
    "Choose a command"
  }, nil, {
    ["clean"] = clean,
    ["convert"] = convert,
    ["eject"] = eject,
    ["shutdown"] = shutdown
  }, nil, "clean_actions")

  return enter
end

local function inject_externalscene()
  local tocleanscene = cleanscene()
  
  local insertjar = sequence.create(nil, {
    "You place a jar inside a hole. It fits perfectly",
    "Table does a slight hiss again and closes the hole",
    "Now table looks like before - solid piece of metal",
    'A message on screen says: "Checking consistency ... Warming up needles..."',
    "You see how inside the glass dome appeared a little robotic arms with needles in them",
    "There is like 12 of them. You are astonished",
    "The arms start to poke the potato-thing with the needles",
    "When they end, they go under the table again",
    "You don't know what the liquid was and what will happen next. You are...",
    "excited at last"
  }, tocleanscene)
  
  local inject_external = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "Insert liquid container"',
    "You hear slight hissing and see how the table has opened a circular hole on the top",
    "You wonder if you should place that jar with strange liquid you have"
  }, nil, {
    ["Put the jar inside"] = insertjar
  })

  --- WRONG CMD

  local clean = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "ERROR: The chamber is already clean"'
  }, "inject_external_options")

  local convert = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "ERROR: Low energy. Cannot transform right now"'
  }, "inject_external_options")

  local eject = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "ERROR: Sequence is not finished"'
  }, "inject_external_options")

  local shutdown = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "Sequence is not finished. Proceed force shutdown?"'
  }, nil, {
    ["y"] = badend_shutdown(),
    ["n"] = sequence.create(nil, {
      "You decided to not shutdown it right now"
    }, "inject_external_options")
  })

  ---
  
  local enter = sequence.create(nil, {
    "You are curious about what will be the next command"
  }, nil, {
    ["inject_external"] = inject_external,
    ["clean"] = clean,
    ["convert"] = convert,
    ["eject"] = eject,
    ["shutdown"] = shutdown
  }, function ()
    gtimer.show(false)
  end, "inject_external_options")

  return enter
end

local waterlocation = ""

-- there should be an action scene - you run into the kitchen/bathroom (choosing right actions) but i don't have more time! :C
local function turnwateroffaction()
  local inject_external = inject_externalscene()
  
  local enter = sequence.create(nil, {
    function()
      return "You run into the " .. waterlocation .. " and turn off the water"
    end
  }, inject_external, nil, function()
    gtimer.cancel()
  end)

  return enter
end

local function afterbootingscene()
  -- GOING TO TURN OFF THE WATER

  local turnoff = turnwateroffaction()

  -- DO NOTHING

  local donothing = sequence.create(nil, {
    "You sit here watching green bar decreasing",
    "...20%...",
    "...10%...",
    "...0%...",
    'A message poped on screen saying: "Operation failed. Place a new object"',
    "The glass dome opened with a click",
    "The water has flood the floor a little"
  }, badend_drowned())
  
  -- DROWNING

  local trytohelp = sequence.create(nil, {
    "You panic a little. What should you do now!?",
    "You are trying to remember all the commands the note gave you...",
    "shutdown? eject? clean? clean!",
    'You type "clean" on the keyboard',
    'And see a message on the screen: "Ejecting liquid... Be sure to turn off the liquid source"',
    "You see water slowly starts to diminish but it's still there and the green bar still decreasing"
  }, nil, {
    ["Turn the water off"] = turnoff,
    ["Do nothing. You tried your best"] = donothing
  })

  local watchingitdrown = sequence.create(nil, {
    "You are sitting still on the chair. Whatching...",
    "how potato quickly drowns in the water",
    "And wait... the green bar decreases. 90%... 80%... 70%..."
  }, nil, {
    ["Try to sink the water from the glass dome"] = trytohelp,
    ["Watch it slowly die"] = donothing
  }, function ()
    -- start timer
    gtimer.start()
  end)
  
  -- INJECTING

  local injecting2 = sequence.create(nil, {
    'You see the screen now shows a timer. "What will happen if i do not turn off it in time?" you wonder',
    "Maybe there is no time to wonder around. What if you have only one attempt?"
  }, nil, {
    ["See what will happen"] = watchingitdrown,
    ["Go and turn off the water in time"] = turnoff
  }, function ()
    gtimer.start()
  end)

  local injecting = sequence.create(nil, {
    'A message on screen says: "Injecting... Turn off the liquid source when timer goes off"'
  }, injecting2, nil, function ()
    -- show timer
    -- start only when turning off water
    local delay = 15
    gtimer = timer.create(delay, love.graphics.getWidth() - 64, 42, function ()
      print("ok")
    end, {
      every = delay / 10,
      callback = function ()
        gstate.potatobar = gstate.potatobar - 10
      end
    })
    gtimer.show(true)
  end)

  -- INJECT CMD
  
  local kitchen = sequence.create(nil, {
    "You go to the kitchen",
    "You turn on the water and go back to the basement"
  }, injecting, nil, function ()
    waterlocation = "kitchen"
  end)

  local bathroom = sequence.create(nil, {
    "You went upstairs to the bathroom",
    "You turned on the water in the sink and went back to the basement"
  }, injecting, nil, function ()
    waterlocation = "bathroom"
  end)
  
  local jar = sequence.create(nil, {
    "You take our the jar you found in bathroom...",
    "but you don't know what to do with it. Where to put it",
    "You are trying to open it but the lid is stuck to the jar"
  }, nil, {
    ["Try to turn on the water in the kitchen"] = kitchen,
    ["Try to turn on the water in the bathroom"] = bathroom
  })
  
  local inject = sequence.create(nil, {
    "You enter the command",
    'A message on the screen says: "No liquid source found"',
    "You wonder what does this mean",
    "Try to guess it"
  }, nil, {
    ["Try the jar with a liquid"] = jar,
    ["Try to turn on the water in the kitchen"] = kitchen,
    ["Try to turn on the water in the bathroom"] = bathroom
  }, nil, "inject_options")
  
  --- ENTER

  local wrongcmd = sequence.create(nil, {
    "You enter the command",
    'A message on screen says: "ERROR: Wrong order of commands"'
  }, "options_2")
  
  local enter = sequence.create(nil, {
    "You are pretty confused about what's going on"
  }, nil, {
    ["inject"] = inject,
    ["inject_external"] = wrongcmd,
    ["clean"] = wrongcmd,
    ["convert"] = wrongcmd,
    ["eject"] = wrongcmd,
    ["shutdown"] = wrongcmd
  }, nil, "options_2")

  return enter
end

local function pcworkingscene()
  local afterboot = afterbootingscene()
  
  --- COMMANDS

  local boot = sequence.create(nil, {
    "You enter the command with a keyboard",
    "The old PC is screeching its hard drives",
    "Lights around the potato start to glow green",
    'The message on the screen says: "Proceed to the next step. WARNING: do not shutdown until procedure is completed!',
    "You also notice that there is now a green bar in the right bottom corner of the screen. What could it be?",
    'A text on the bar says "100%"'
  }, afterboot, nil, function ()
    gstate.potatobar = 100
  end)

  local wrongcmd = sequence.create(nil, {
    "You enter the command with a keyboard but nothing happens",
    'The message on the screen says: "You need to boot first"'
  }, "cmd_options")

  --- OPTIONS
  
  local options = sequence.create(nil, {
    "You have some options to choose from"
  }, nil, {
    ["boot"] = boot,
    ["inject"] = wrongcmd,
    ["inject_external"] = wrongcmd,
    ["clean"] = wrongcmd,
    ["convert"] = wrongcmd,
    ["eject"] = wrongcmd,
    ["shutdown"] = wrongcmd
  }, nil, "cmd_options")
  
  local enter = sequence.create(nil, {
    "You hear a loud beep and see a dark terminal on the screen",
    "There is only cursor blinking",
    "You starting to remember you have that paper note from the fireplace",
    "You come to the conclusion that those words in the note were not just some random words but the commands for the terminal",
    "But you don't know what any of them are doing"
  }, options)
  
  return enter
end

local function basementscene()
  local pcturned = pcworkingscene()
  
  local pressbutton = sequence.create(nil, {
    "You press the button"
  })

  if gstate.houseinspected() then
    table.insert(pressbutton.textlist, "You hear a loud fan start working")
    table.insert(pressbutton.textlist, "The monitor slowly starts to light up")
    table.insert(pressbutton.textlist, 'The "potato" starts to light up too... wait, it\'s the lights inside a glass dome')
    pressbutton.continuewith = pcturned
  else
    table.insert(pressbutton.textlist, "Nothing happens")
    pressbutton.continuewith = "first_actions"
  end
  
  local turnon = sequence.create(nil, {
    "You search for the turn on button",
    "It's a PC with a monitor and a keyboard",
    "There is some button on the side of a monitor with a bottle symbol in circle on it",
    "Looks like a modded turn on button"
  }, nil, {
    ["Press it"] = pressbutton
  })
  
  local inspect = sequence.create(nil, {
    "You are looking at the table, on both sides, trying to look under and behind it, but it's just a full-metal table without any door or anything"
  }, "first_actions")
  
  local knock = sequence.create(nil, {
    "You are knocking on the dome glass but nothing happens",
    "At lest the potato seem to be silent and steady"
  }, "first_actions")
  
  local enter = sequence.create(nil, {
    "Time passes by. You are sitting in front of a table with a weird potato and an old PC",
    "What will you do next?"
  }, nil, {
    ["Knock on the dome glass"] = knock,
    ["Inspect the table"] = inspect,
    ["Try to turn on the PC"] = turnon
  }, nil, "first_actions")

  if not gstate.houseinspected() then
    enter.actionlist["Inspect the house now"] = sequence.create(nil, {
      "You decide to inspect the house"
    }, nil, nil, function ()
      gstate.inspecthousept3 = true
      
      if scene.transitioncallback then
        scene.transitioncallback("from basement")
      end
    end)
  end

  return enter
end

local function setupscene()
  local basement = basementscene()
  
  local afterdialog = sequence.create(nil, {
    "And you was left alone in this basement",
    "You are looking around and see that. That thing he was talking about",
    "No, not the old PC... The... Thing...",
    "Potato? Is that really a potato? It can't be. You genuinely surprised. You had never worked with a potato in your entire career",
    '"Why someone will put a potato inside a glass dome and secure it with the screws"',
    "Well, the basement feels pretty empty. You can see some garbage laying on the floor. Mostly there is only the table taking huge amount of space",
    "Oh, and a chair. You came to the table and sat on the chair, thinking what to do with that thing"
  }, basement)
  
  local say = nil

  if gstate.bedroom then
    say = sequence.create(nil, {
      "You still remember about the corpse"
    }, nil, {
      ["Tell him about the dead body"] = sequence.create(nil, {
        "You see that agent is surprized and... glad about that?"
      }, sequence.create(AGENT_NAME, {
        "Oh, damn. I need to see that. Finally something to do. I'll call the police to investigate. Those bastards have been checking the house but didn't go to the second floor. Lazy donuts.",
        "Thanks for the investigation, Cave. Without you i'd... we'd don't know about the body and what could've happend here.",
        "...",
        "Okay. Do your thing. I'll be around here."
      }, afterdialog))
    })
  else
    say = sequence.create(nil, {
      "You are staying still. Silent"
    }, sequence.create(AGENT_NAME, {
      "Alright. Good luck. If you need me, i'm at the porch"
    }, afterdialog))
  end
  
  local annoyed = sequence.create(nil, {
    "You rather annoyed about agent's jokes than pissed off"
  }, say)
  
  local deadbody1 = nil

  if gstate.bedroom then
    deadbody1 = sequence.create(nil, {
      "You remember about the dead body and..."
    }, annoyed)
  else
    deadbody1 = sequence.create(AGENT_NAME, {
      "Yeah. I think i'm gonna go smoke while you are doing your mumbo-jumbo"
    }, annoyed)
  end
  
  local thinking1 = sequence.create(nil, {
    "You still don't get it. Does he doubting you?"
  }, deadbody1)
  
  local introvoice1 = sequence.create(AGENT_NAME, {
    "Brace yourself. Hah. I am looking at this thing for the second time but I still don't know what this is"
  }, thinking1)

  return introvoice1
end

function scene:load(callback)
  scene.transitioncallback = callback

  b.loadassets()
  sequence.loadassets()

  gstate.location = "Basement"

  if gstate.inspecthousept3 then
    runner = sequence.run(basementscene())
  else
    runner = sequence.run(setupscene())
  end
end

function scene:draw()
  love.graphics.setBackgroundColor(45 / 255, 50 / 255, 73 / 255)

  runner:draw()

  love.graphics.setColor(250 / 255, 248 / 255, 236 / 255)
  love.graphics.print("Location: " .. gstate.location, 32, love.graphics.getHeight() - 72)
  
  if gstate.potatobar > -1 then
    local width = 200
    local height = 45
    love.graphics.rectangle("fill", love.graphics.getWidth() - width - 24, love.graphics.getHeight() - 72, (gstate.potatobar / 100) * width, height)
    love.graphics.setColor(0, 5 / 255, 16 / 255)
    love.graphics.print(tostring(math.floor(gstate.potatobar)) .. "%", love.graphics.getWidth() - width / 2, love.graphics.getHeight() - 72)
  end

  if gtimer then
    gtimer.draw()
  end
end

function scene:mouseclick(x, y, button)
	if button == 1 then
    if not sequence.handleclick(runner, x, y) then
      sequence.next(runner)
    end
	end
end

return scene