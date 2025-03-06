local ox_lib = exports['ox_lib']:getLib()
local dutyStatus = {}

-- Function to create a duty blip
function createBlip(source, department, callsign, color)
    local ped = GetPlayerPed(source)
    local blip = AddBlipForEntity(ped)
    SetBlipSprite(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, color)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(department .. ' - ' .. callsign)
    EndTextCommandSetBlipName(blip)

    dutyStatus[source].blip = blip
end

-- Function to remove a duty blip
function removeBlip(source)
    if dutyStatus[source] and dutyStatus[source].blip then
        RemoveBlip(dutyStatus[source].blip)
        dutyStatus[source].blip = nil
    end
end

-- Function to give weapons
function giveWeapons(source, weapons)
    local ped = GetPlayerPed(source)
    for _, weapon in ipairs(weapons) do
        GiveWeaponToPed(ped, GetHashKey(weapon), 250, false, true)
    end
end
