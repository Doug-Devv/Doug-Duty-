dutyStatus = {}
activeCalls = {}

-- Permission check function
function hasPermission(source, perm)
    return IsPlayerAceAllowed(source, perm)
end

RegisterCommand('duty', function(source)
    local options = {}
    for _, dept in ipairs(departments) do
        if hasPermission(source, dept.permission) then
            table.insert(options, { label = dept.name, value = dept.name })
        end
    end

    if #options == 0 then
        ox_lib.notify({ title = 'Duty System', description = 'You do not have permission to join any department.', type = 'error' })
        return
    end

    ox_lib.dialog({
        id = 'duty_dialog',
        title = 'Go On Duty',
        fields = {
            { id = 'department', label = 'Select Department', type = 'select', options = options },
            { id = 'callsign', label = 'Enter Callsign', type = 'input' }
        }
    }, function(data)
        if data then
            for _, dept in ipairs(departments) do
                if dept.name == data.department then
                    dutyStatus[source] = { department = data.department, callsign = data.callsign, onDuty = true }
                    TriggerClientEvent('createBlip', source, data.department, data.callsign, dept.blipColor)
                    ox_lib.notify({ title = 'Duty System', description = 'On Duty in ' .. data.department .. ' as ' .. data.callsign, type = 'success' })
                    
                    ox_lib.dialog({
                        id = 'weapon_confirm',
                        title = 'Receive Duty Weapons?',
                        fields = { { id = 'confirm', label = 'Would you like to receive your duty weapons?', type = 'checkbox' } }
                    }, function(weaponData)
                        if weaponData and weaponData.confirm then
                            TriggerClientEvent('giveWeapons', source, dept.weapons)
                            ox_lib.notify({ title = 'Duty System', description = 'Weapons issued for ' .. data.department, type = 'success' })
                        end
                    end)
                    break
                end
            end
        end
    end)
end)

RegisterCommand('kickoffduty', function(source, args)
    if not hasPermission(source, 'duty.kick') then
        ox_lib.notify({ title = 'Duty System', description = 'You do not have permission to kick users off duty.', type = 'error' })
        return
    end

    local target = tonumber(args[1])
    if dutyStatus[target] then
        TriggerClientEvent('removeBlip', target)
        dutyStatus[target] = nil
        ox_lib.notify({ title = 'Duty System', description = 'User has been kicked off duty', type = 'error' })
    end
end)

AddEventHandler('playerDropped', function()
    local source = source
    TriggerClientEvent('removeBlip', source)
    dutyStatus[source] = nil
end)

print("Freech Duty script loaded with ox_lib integration, department dropdown, ACE permissions, blips, and weapons")
