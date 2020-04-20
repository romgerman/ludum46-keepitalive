local function rectpointcollision(x, y, w, h)
  return function (posx, posy)
    return (posx >= x and
            posx <= x + w and
            posy >= y and
            posy <= y + h)
  end
end

return rectpointcollision