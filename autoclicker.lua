local toggle_key = "capslock"  
local delay = 10               

function OnEvent(event, arg)
    if event == "PROFILE_ACTIVATED" then
        EnablePrimaryMouseButtonEvents(true)
        OutputLogMessage("[AutoClicker] Script loaded. Toggled by: %s\n", toggle_key)
        
        repeat
            if IsKeyLockOn(toggle_key) then
                PressMouseButton(1)
                Sleep(10)
                ReleaseMouseButton(1)
                Sleep(delay)
            else
                Sleep(50)
            end
        until false
    end
end
