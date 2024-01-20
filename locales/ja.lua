local Translations = {
    error = {
        cooldown = 'クールタイム中...'
    },
    info = {
        invisibled = '%d秒間NPCに紛れ込みます',
        visible_countdown = 'あと%d秒で名前が表示されます',
        visibled = '名前が表示されました',
        can_invisible = '一定時間経過したため再び名前を非表示出来るようになった',
        keymap_description = '一定時間NPCに紛れ込む'
    },
    command = {
        nameplate = {
            help = '一定時間名前を非表示にしてNPCに紛れ込む',
        },
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
