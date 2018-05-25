-- @Date:   2017-06-11T11:07:04+02:00
-- @Project: FiveM Tools
-- @Last modified time: 2017-06-11T18:33:29+02:00
-- @License: GNU General Public License v3.0

RegisterNetEvent('cv_menu2:Open')
AddEventHandler('cv_menu2:Open', function(name)
  MenusManager:Open(name)
end)

RegisterNetEvent('cv_menu2:Next', name)
AddEventHandler('cv_menu2:Next', function()
  MenusManager:Next(name)
end)

RegisterNetEvent('cv_menu2:Add', name, buttons, settings)
AddEventHandler('cv_menu2:Add', function()
  MenusManager:Add(name, buttons, settings)
end)

RegisterNetEvent('cv_menu2:Close')
AddEventHandler('cv_menu2:Close', function()
  MenusManager:Close()
end)

RegisterNetEvent('cv_menu2:IsOpened', callback)
AddEventHandler('cv_menu2:IsOpened', function()
  callback(MenusManager.opened)
end)

RegisterNetEvent('cv_menu2:Back')
AddEventHandler('cv_menu2:Back', function()
  MenusManager:Back()
end)

RegisterNetEvent('cv_menu2:Current', callback)
AddEventHandler('cv_menu2:Current', function()
  callback(MenusManager.curent)
end)

RegisterNetEvent('cv_menu2:Freeze')
AddEventHandler('cv_menu2:Freeze', function(status)
  MenusManager:Freeze(status)
end)
