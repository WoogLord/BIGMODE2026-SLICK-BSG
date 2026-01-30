function drawButton(_button)
    if _button.r or _button.b or _button.g then love.graphics.setColor(_button.r,_button.b,_button.g)
    else love.graphics.setColor(0.5,0.5,0.5)
    end
    if _button.invis then love.graphics.setColor(0,0,0,0) end
    love.graphics.rectangle("fill",_button.x, _button.y, _button.w, _button.h)
    love.graphics.setColor(1,1,1)
    if _button.invis then else love.graphics.printf(_button.label, _button.x, _button.y + _button.h - (buttonFont:getHeight()*1.5), _button.w, "center") end
end

function nineSlicer(_x, _y, _w, _h, _boxColor, _nineSlice)
    love.graphics.setColor(_boxColor)
    love.graphics.rectangle("fill", _x, _y, _w, _h)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(_nineSlice.fill, _x, _y, 0, 2, 2)
    love.graphics.draw(_nineSlice.outline, _x, _y, 0, 2, 2)
end

-- same logic as floaters
function addExplosion()

end

function doExplosions()

end

function addFloater(_number, _target, _r, _g, _b)
    local floaterX, floaterY = _target.x, _target.y
    table.insert(floater, {
          text = _number
        , x = floaterX, y = floaterY
        , r = _r, g = _g, b = _b
        , targetY = floaterY - (10 * gfxScale)
        , time = 0
    })
    love.graphics.print(_number, floaterX, floaterY, 0, gfxScale, gfxScale)
end

function doFloaters()
    for i, f in ipairs(floater) do
        f.y = f.y + ((f.targetY-f.y) / (10 * gfxScale))
        f.time = f.time + 1
        if f.time > 60 then
            table.remove(floater, i)
        end
    end
end
