local b = require("ui.button")

local SEQUENCE = {}

local narratorimage = nil

local function loadassets()
  narratorimage = love.graphics.newImage("assets/narrator.png")
end

local function createsequence(voice, textlist, continuewith, actionlist, callback, name)
  return {
    voice = voice,
    textlist = textlist,
    continuewith = continuewith,
    actionlist = actionlist,
    callback = callback,
    name = name
  }
end

-- Returns sequence runner
local function runsequence(sequence, override)
  local state = {
    seq = nil,
    textindex = 1,
    list = {},
    lookup = {}
  }

  local o = {}

  local xoffset = 100
  local yoffset = 400
  local maxwidth = 800
  local maxcolumns = 3
  local buttonoffset = 40
  local buttonheight = 45

  local function generateui(seq)
    if seq.name then
      state.lookup[seq.name] = seq
    end
    
    seq.ui = {}
    seq.ui.text = {}

    for i, item in ipairs(seq.textlist) do
      table.insert(seq.ui.text, b.createbutton(
        100, 100, 
        800, 250,
        item, {
          animate = 30
        }
      ))
    end

    if seq.voice then
      seq.ui.voice = b.createbutton(
        150, 66,
        400, 45,
        seq.voice, {
          nooffset = true
        }
      )
    end

    if type(seq.continuewith) == "table" then
      seq.continuewith = generateui(seq.continuewith)
    end

    if seq.actionlist then
      seq.ui.actions = {}

      local buttonwidth = (maxwidth - maxcolumns * buttonoffset + buttonoffset) / maxcolumns

      local index = 0

      if type(seq.actionlist) == "function" then
        local dump = require("dump")
        print(dump(seq.textlist))
      end
      
      for key, actionseq in pairs(seq.actionlist) do
        table.insert(seq.ui.actions, b.createbutton(
          xoffset + (buttonwidth + buttonoffset) * (index - math.floor(index / maxcolumns) * maxcolumns),
          yoffset + (buttonoffset + buttonheight) * math.floor(index / maxcolumns),
          buttonwidth, buttonheight,
          key, {
            nooffset = true,
            onclick = function (butt)
              if override then
                SEQUENCE.nextsequence(override, key)
              else
                SEQUENCE.nextsequence(o, key)
              end
            end
          }
        ))

        if type(seq.actionlist[key]) == "table" then
          seq.actionlist[key] = generateui(actionseq)
        end

        index = index + 1
      end
    end

    return seq
  end

  state.seq = generateui(sequence)

  local draw = function ()    
    state.seq.ui.text[state.textindex]:render()

    if state.seq.ui.voice then
      state.seq.ui.voice:render()
    else
      local panel = state.seq.ui.text[state.textindex]

      love.graphics.draw(
        narratorimage, 
        panel.posx + panel.width - narratorimage:getWidth(),
        panel.posy + panel.height - narratorimage:getHeight() - 9
      )
    end

    if state.seq.ui.actions and not state.seq.ui.text[state.textindex]:animating() and state.textindex >= #state.seq.textlist then
      for i, action in pairs(state.seq.ui.actions) do
        action:render()
      end
    end
  end
  
  o = {
    draw = draw,
    state = state,
    finishanimation = function ()
      state.seq.ui.text[state.textindex]:finishanimation()
    end
  }
  
  return o
end

function SEQUENCE.nextsequence(seqrunner, choosenaction)
  if seqrunner.state.seq.ui.text[seqrunner.state.textindex]:animating() then
    seqrunner.state.seq.ui.text[seqrunner.state.textindex]:finishanimation()
    return
  end
  
  if seqrunner.state.textindex >= #seqrunner.state.seq.textlist then
    if seqrunner.state.seq.callback then
      seqrunner.state.seq.callback()
      seqrunner.state.seq.callback = nil
    end
    
    if seqrunner.state.seq.continuewith then
      local seq = seqrunner.state.seq.continuewith

      if type(seq) == "string" then
        seq = SEQUENCE.lookupseqbyname(seqrunner, seq)
      end
      
      seqrunner.state.seq = seq
      seqrunner.state.textindex = 1
    end

    if seqrunner.state.seq.actionlist and choosenaction then
      local actionseq = seqrunner.state.seq.actionlist[choosenaction]

      if type(actionseq) == "string" then
        seqrunner.state.seq = SEQUENCE.lookupseqbyname(seqrunner, actionseq)
      elseif type(actionseq) == "function" then
        local newseq = actionseq()

        if type(newseq) == "string" then
          newseq = SEQUENCE.lookupseqbyname(seqrunner, newseq)
        end

        seqrunner.state.seq = newseq
      else
        seqrunner.state.seq = actionseq
      end
      
      seqrunner.state.textindex = 1
    end    
  else
    seqrunner.state.textindex = seqrunner.state.textindex + 1
  end
end

function SEQUENCE.lookupseqbyname(seqrunner, name)
  return seqrunner.state.lookup[name]
end

local function handleclick(seqrunner, x, y)
  if seqrunner.state.seq.actionlist then
    for i, button in pairs(seqrunner.state.seq.ui.actions) do
      if button.clickhandler(x, y) then
        return true
      end
    end
  end
end

local function preparesequence(runner, sequence, force)
  local state = runsequence(sequence, runner).state

  local function visit(seq)
    if seq.name and (not runner.state.lookup[seq.name] or force) then
      runner.state.lookup[seq.name] = seq
    end

    if seq.continuewith then
      if type(seq.continuewith) == "table" then
        visit(seq.continuewith)
      end
    end

    if seq.actionlist then
      for key, value in pairs(seq.actionlist) do
        if type(value) == "table" then
          visit(value)
        end
      end
    end
  end

  visit(state.seq)

  return state.seq
end

local function changelookupitem(seqrunner, name, newitem)
  seqrunner.state.lookup[name] = preparesequence(seqrunner, newitem)
  return seqrunner.state.lookup[name]
end

return {
  create = createsequence,
  run = runsequence,
  next = SEQUENCE.nextsequence,
  handleclick = handleclick,
  changelookupitem = changelookupitem,
  prepare = preparesequence,
  loadassets = loadassets
}