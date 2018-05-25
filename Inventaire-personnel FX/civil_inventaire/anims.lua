--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 10/05/2017
-- Time: 13:50
-- To change this template use File | Settings | File Templates.
--

function animsAction(animObj)
    RequestAnimDict(animObj.lib)
    while not HasAnimDictLoaded(animObj.lib) do
        Citizen.Wait(0)
    end
    if HasAnimDictLoaded(animObj.lib) then
        TaskPlayAnim(GetPlayerPed(-1), animObj.lib , animObj.anim ,8.0, -8.0, -1, 0, 0, false, false, false)
    end
end
