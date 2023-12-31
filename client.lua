local QBCore = exports['qb-core']:GetCoreObject()

local hidePlayers = {}

RegisterNetEvent('azqb-nameplate:client:show', function(state)
    if state then
        QBCore.Functions.Notify(Lang:t('success.names_activated'), 'success')
    else
        QBCore.Functions.Notify(Lang:t('error.names_deactivated'), 'error')
    end
end)

RegisterNetEvent('azqb-nameplate:client:sync', function(shows, players)
    hidePlayers = shows

    for id, player in pairs(players) do
        local playeridx = GetPlayerFromServerId(id)
        local ped = GetPlayerPed(playeridx)

        local Tag = CreateFakeMpGamerTag(ped, player.name, false, false, '', false)
        SetMpGamerTagAlpha(Tag, 0, 255)

        if hidePlayers[id] ~= nil then
            SetMpGamerTagVisibility(Tag, 0, false)
            RemoveMpGamerTag(Tag)
        else
            SetMpGamerTagVisibility(Tag, 0, true)
        end
    end
end)
