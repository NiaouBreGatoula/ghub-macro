local activation_key = "capslock"
local fire_button = 1

local recoil_profile = {h = 0.0, v = 1.0, delay = 7}
-- h = 0.0 tha pigenei full eftheia deksia + aristera - (p.x -0.2 tha pigenei ligo aristera),
-- to v einai poso kathe fora tha katevainei to pontiki (vertical recoil),
-- kai to delay einai poso grigora tha ginetai kathe kinisi tou recoil (xrono se ms).

function randomize(base, factor)
    return base * (1 + factor * math.random())
end

function move_horizontal(val)
    MoveMouseRelative(math.floor(randomize(0.7, 1) * val), 0)
end

function move_vertical(val)
    MoveMouseRelative(0, math.floor(randomize(0.7, 1) * val))
end

function apply_recoil()
    local h = recoil_profile.h
    local v = recoil_profile.v

    local h_frac = math.abs(h) - math.floor(math.abs(h))
    local v_frac = math.abs(v) - math.floor(math.abs(v))

    local x_count, y_count = 0, 0

    repeat
        if h ~= 0 then
            if h < 0 then
                move_horizontal(h + h_frac)
            else
                move_horizontal(h - h_frac)
            end
        end

        if v ~= 0 then
            if v < 0 then
                move_vertical(v + v_frac)
            else
                move_vertical(v - v_frac)
            end
        end

        if h_frac ~= 0 then
            x_count = x_count + h_frac
            if x_count >= 1 * randomize(0.7, 1) then
                move_horizontal(h > 0 and 1 or -1)
                x_count = 0
            end
        end

        if v_frac ~= 0 then
            y_count = y_count + v_frac
            if y_count >= 1 * randomize(0.7, 1) then
                move_vertical(v > 0 and 1 or -1)
                y_count = 0
            end
        end

        Sleep(math.floor(randomize(0.8, 0.5) * recoil_profile.delay))
    until not IsMouseButtonPressed(fire_button)
end

function OnEvent(event, arg)
    if event == "PROFILE_ACTIVATED" then
        EnablePrimaryMouseButtonEvents(true)
    elseif event == "PROFILE_DEACTIVATED" then
        ReleaseMouseButton(fire_button)
    end

    if IsKeyLockOn(activation_key) then
        if event == "MOUSE_BUTTON_PRESSED" and arg == fire_button then
            apply_recoil()
        end
    end
end
