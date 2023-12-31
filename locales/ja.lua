local Translations = {
    error = {
        names_deactivated = '他人にネームタグを表示しないようにしました',
    },
    success = {
        names_activated = '他人にネームタグを表示するようにしました',
    },
    commands = {
        ["nameplate_description"] = '他人へのネームタグ表示状態を切り替えます'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
