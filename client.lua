local QBCore = exports['qb-core']:GetCoreObject()

local hidePlayers = {}
local allPlayers = {}

local showName = true

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

RegisterNetEvent('azqb-nameplate:client:sync', function(shows, players)
    hidePlayers = shows
    allPlayers = players
end)

RegisterCommand("hidename", function()
    TriggerServerEvent("azqb-nameplate:server:hide")
end, false)
RegisterKeyMapping("hidename", Lang:t('info.keymap_description'), 'keyboard', 'F9')

RegisterCommand("togglename", function()
    showName = not showName
end, false)
RegisterKeyMapping("togglename", Lang:t('info.toggle_keymap_description'), 'keyboard', 'F11')

CreateThread(function()
    while true do
        Wait(100)
        for _, player in pairs(allPlayers) do
            local playerId = GetPlayerFromServerId(tonumber(player.id))
            if NetworkIsPlayerActive(playerId) then
                local ped = GetPlayerPed(playerId)
                local tag = CreateMpGamerTag(ped, player.name, false, false, '', 0)
                if hidePlayers[player.cid] ~= nil or not showName then
                    SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
                    SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, false)
                else
                    SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, true)
                    SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, NetworkIsPlayerTalking(playerId))
                    SetMpGamerTagAlpha(tag, gtComponent.AUDIO_ICON, 255)
                end
            end
        end
    end
end
)
