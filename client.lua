local QBCore = exports['qb-core']:GetCoreObject()

local hidePlayers = {}
local allPlayers = {}

local showName = true
local distanceDisplay = 30

local gtComponent = {
    GAMER_NAME = 0,
    CREW_TAG = 1,
    healthArmour = 2,
    BIG_TEXT = 3,
    AUDIO_ICON = 4,
    MP_USING_MENU = 5,
    MP_PASSIVE_MODE = 6,
    WANTED_STARS = 7,
    MP_DRIVER = 8,
    MP_CO_DRIVER = 9,
    MP_TAGGED = 10,
    GAMER_NAME_NEARBY = 11,
    ARROW = 12,
    MP_PACKAGES = 13,
    INV_IF_PED_FOLLOWING = 14,
    RANK_TEXT = 15,
    MP_TYPING = 16
}

RegisterNetEvent('azqb-nameplate:client:hideSync', function(hides)
    hidePlayers = hides
end)

RegisterNetEvent('azqb-nameplate:client:allSync', function(players)
    allPlayers = players
end)

RegisterCommand("hidename", function()
    TriggerServerEvent("azqb-nameplate:server:hide")
end, false)
RegisterCommand("hidenameforce", function()
    TriggerServerEvent("azqb-nameplate:server:hide-force")
end, false)
RegisterKeyMapping("hidename", Lang:t('info.keymap_description'), 'keyboard', 'F9')

RegisterCommand("togglename", function()
    showName = not showName
end, false)
RegisterKeyMapping("togglename", Lang:t('info.toggle_keymap_description'), 'keyboard', 'F11')

RegisterCommand("setemoji", function(source, args, raw)
    if args[1] == nil then
        return
    end
    TriggerServerEvent("azqb-nameplate:server:set-emoji", args[1])
end, false)

CreateThread(function()
    while true do
        Wait(100)
        local localCoords = GetEntityCoords(PlayerPedId())
        for _, player in pairs(allPlayers) do
            local playerId = GetPlayerFromServerId(tonumber(player.id))
            if NetworkIsPlayerActive(playerId) then
                local ped = GetPlayerPed(playerId)
                local remoteCoords = GetEntityCoords(ped)
                local distance = #(remoteCoords - localCoords)
                local tag = CreateMpGamerTag(ped, player.name, false, false, '', 0)
                SetMpGamerTagAlpha(tag, gtComponent.AUDIO_ICON, 255)
                SetMpGamerTagAlpha(tag, gtComponent.GAMER_NAME, 225)
                if distance > distanceDisplay or not HasEntityClearLosToEntity(PlayerPedId(), ped, 17) or hidePlayers[player.cid] ~= nil or not showName then
                    SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
                    SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, false)
                else
                    SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, true)
                    SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, NetworkIsPlayerTalking(playerId))
                end
            end
        end
    end
end
)
