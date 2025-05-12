local activation_key = "capslock"
local min_interval_ms = 1800
local max_interval_ms = 4200
local running = false

function random_sleep(min_ms, max_ms)
    return math.random(min_ms, max_ms)
end

function slight_mouse_wiggle() -- move smooth pls
    local total_x = math.random(-100, 100)
    local total_y = math.random(-100, 100)
    local steps = math.random(8, 20)
    local step_x = total_x / steps
    local step_y = total_y / steps

    for i = 1, steps do
        local jitter_x = step_x + math.random(-1,1)
        local jitter_y = step_y + math.random(-1,1)
        MoveMouseRelative(math.floor(jitter_x), math.floor(jitter_y))
        Sleep(math.random(8, 16))
    end

    OutputLogMessage("[DEBUG] Mouse smooth moved: (%d, %d) in %d steps\n", total_x, total_y, steps)
end


function light_keyboard_input()
    local keys = {"lshift", "lctrl", "rshift", "rctrl"}
    local key = keys[math.random(1, #keys)]
    PressKey(key)
    Sleep(20)
    ReleaseKey(key)
    OutputLogMessage("[DEBUG] Simulated key: %s\n", key)
end

function light_scroll()
    local amount = math.random(-1, 1)
    if amount ~= 0 then
        MoveMouseWheel(amount)
        OutputLogMessage("[DEBUG] Scrolled: %d\n", amount)
    end
end

function start_fake_activity()
    if running then return end
    running = true
    OutputLogMessage("[AFK] %s is ON. Starting fake activity...\n", activation_key)

    local cycle = 0

    repeat
        if not IsKeyLockOn(activation_key) then
            OutputLogMessage("[AFK] %s is OFF. Stopping.\n", activation_key)
            running = false
            break
        end

        local delay = random_sleep(min_interval_ms, max_interval_ms)
        OutputLogMessage("[DEBUG] Waiting %d ms\n", delay)
        Sleep(delay)

        slight_mouse_wiggle()
        cycle = cycle + 1
        OutputLogMessage("[DEBUG] Cycle: %d\n", cycle)

        if cycle % 2 == 0 then
            light_scroll()
        end

        if cycle % 3 == 0 then
            light_keyboard_input()
        end

    until false
end

function OnEvent(event, arg)
    if event == "PROFILE_ACTIVATED" then
        EnablePrimaryMouseButtonEvents(true)
        math.randomseed(os.time())
        OutputLogMessage("[AFK] Script loaded. Toggle with: %s\n", activation_key)
    end

    if event == "KEYBOARD_KEY_PRESSED" or event == "MOUSE_BUTTON_PRESSED" then
        if IsKeyLockOn(activation_key) and not running then
            start_fake_activity()
        end
    end
end
