
function animsAction(data)
  Citizen.CreateThread(function()

      RequestAnimDict( data.lib )
      while not HasAnimDictLoaded( data.lib ) do
          Citizen.Wait(0)
      end
      if HasAnimDictLoaded( data.lib ) then
          TaskPlayAnim( GetPlayerPed(-1), data.lib , data.anim ,8.0, -8.0, -1, 0, 0, false, false, false )
      end

  end)
end

function animsActionScenario(data)
  Citizen.CreateThread(function()

      local ped = GetPlayerPed(-1);

      if ped then
          local pos = GetEntityCoords(ped);
          local head = GetEntityHeading(ped);
          TaskStartScenarioInPlace(ped, data.anim, 0, false)
      end

  end)
end


---------------------------------- SAVER ----------------------------------

function Saver()
  LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
  local LastPosH = GetEntityHeading(GetPlayerPed(-1))
  TriggerServerEvent("project:savelastpos", LastPosX , LastPosY , LastPosZ, LastPosH)
end

--------------------------------- CARTE -----------------------------------------------

function carte()
  --SetNuiFocus(true)
  TriggerServerEvent('gc:openMeIdentity')
  SendNUIMessage({method = 'openGuiIdentity',  data = data})
  menuIsOpen = 1
end

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({method = 'closeGui'})
  menuIsOpen = 0
end

function phoneMenu()
   TriggerEvent('phone:toggleMenu') 
end


---------------------------------- GPS ----------------------------------

 
function DeadCheck() 
  local dead = IsEntityDead(GetPlayerPed(-1))
  if dead ~= isDead then 
    isDead = dead
    SendNUIMessage({event = 'updateDead', isDead = isDead})
  end
end


RegisterNetEvent("supr")
AddEventHandler("supr", function() 
end)

function supr()
  TriggerServerEvent("suprs")
  x, y, z = x, y, z
  SetWaypointOff(x, y, z)
end

RegisterNetEvent("comico")
AddEventHandler("comico", function() 
end)

function comico()
  TriggerServerEvent("comicos")
  x, y, z = 462.319854736328, -989.413513183594, 24.9148712158203
  SetNewWaypoint(x, y, z)
end


RegisterNetEvent("hopi")
AddEventHandler("hopi", function() 
end)

function hopi()
  TriggerServerEvent("hopis")
  x, y, z = 356.979156494141, -596.751220703125, 28.7816715240479
  SetNewWaypoint(x, y, z)
end


RegisterNetEvent("concepoint")
AddEventHandler("concepoint", function() 
end)

function concepoint()
  TriggerServerEvent("concepoints")
  x, y, z = -34.2844390869141, -1101.75170898438, 26.4223537445068
  SetNewWaypoint(x, y, z)
end

RegisterNetEvent("pole")
AddEventHandler("pole", function() 
end)

function pole()
  TriggerServerEvent("poles")
  x, y, z = -266.775268554688, -959.946960449219, 31.2197742462158
  SetNewWaypoint(x, y, z)
end

RegisterNetEvent('project:notify')
RegisterNetEvent("project:spawnlaspos")

local firstspawn = 0
local loaded = false

--Boucle Thread d'envoie de la position toutes les x secondes vers le serveur pour effectuer la sauvegarde
Citizen.CreateThread(function ()
  while true do
  --Durée entre chaque requêtes : 60000 = 60 secondes
  Citizen.Wait(60000)
    --Récupération de la position x, y, z du joueur
    LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    --Récupération de l'azimut du joueur
      local LastPosH = GetEntityHeading(GetPlayerPed(-1))
    --Envoi des données vers le serveur
      TriggerServerEvent("project:savelastpos", LastPosX , LastPosY , LastPosZ, LastPosH)
  end
end)

--Event permetant au serveur d'envoyez une notification au joueur
RegisterNetEvent('project:notify')
AddEventHandler('project:notify', function(alert)
    if not origin then
        Notify(alert)
    end
end)

--Notification joueur
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

--Event pour le spawn du joueur vers la dernière position connue
AddEventHandler("project:spawnlaspos", function(PosX, PosY, PosZ)
  if not loaded then
    SetEntityCoords(GetPlayerPed(-1), PosX, PosY, PosZ, 1, 0, 0, 1)
    Notify("~h~~g~Vous voici à votre dernière position")
  end
end)

--Action lors du spawn du joueur
AddEventHandler('playerSpawned', function(spawn)
--On verifie que c'est bien le premier spawn du joueur
if firstspawn == 0 then
  TriggerServerEvent("project:SpawnPlayer")
  firstspawn = 1
end
end) 


----------------------------------------------------------------------------------------------------------------
