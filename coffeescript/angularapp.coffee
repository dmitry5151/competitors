manageCompetitors = angular.module 'manageCompetitors', []

manageCompetitors.controller 'compCtrl', ($scope, $http) ->
  $scope.work = "Приложение работает!"
  $scope.newColor = {}
  $scope.comp = {}
  $scope.edit = []
  $scope.tab = {}
  $scope.bgEdit = {}
  $scope.updPatternTxt = "Обновить"

  #$scope.bgColors = []

  #$scope.bgColorCurrent = $scope.settings.background

  #$scope.newColor = "#222"
  # Активация вкладок
  $scope.showTab = (num) -> # num - номер активируемой вкладки
    $scope.tab.number = num
    for tab in $scope.tabs
      tab.class = ""
    $scope.tabs[num-1].class = "active"
    return

  ###
  Вкладки приложения
  ###
  $scope.tabs = [
    {tab: 1, name: "Соискатели", "class": "active", id: "tab-1", file: "competitors.html", show: true}
    {tab: 2, name: "Настройки", "class": "", id: "tab-2", file: "settings.html", show: false}
    {tab: 3, name: "Об авторе", "class": "", id: "tab-3", file: "author.html", show: false}
  ]


  ###
  Загрузка соискателей
  ###
  $http.get("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/applicants").success (data) ->
    $scope.competitors = data
    return
  .error (data, status, headers, config) ->
    console.log status
    return

  ###
  Удаление соискателя
  ###
  $scope.deleteUser = (name, surname, id, index) ->
    confirmDelete = confirm "Удалить соискателя #{name} #{surname}?"
    if confirmDelete
      $http.delete("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/applicants/#{id}").success ->
        $scope.competitors.splice(index, 1)
        return
      .error (data, status, headers, config) ->
        console.log status
        return
    return

  ###
  Редактирование соискателя
  ###
  $scope.showEdit = (visible, index) ->
    if visible
      $scope.edit[index] = true
      #$scope.edit[index].index = index
    else
      if $scope.competitors[index].name != undefined and $scope.competitors[index].surname != undefined
        $scope.edit[index] = false
    return

  $scope.editUser = (id, name, surname, index) ->
    if name != undefined and surname != undefined
      user =
        "name": name
        "surname": surname
      $http.put("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/applicants/#{id}", user).success ->
        $scope.edit[index] = false
        return
    #console.log name, surname, id
    return

  ###
  Удаление всех соискателей
  ###
  $scope.deleteAllUsers = ->
    confirmDelete = confirm "Удалить всех соискателей?"
    if confirmDelete
      $http.delete("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/applicants").success ->
        $scope.competitors = []
        return
      .error (data, status, headers, config) ->
        console.log status
        return
    return

  ###
  Добавление соискателя
  ###
  $scope.showAdd = (visible) ->
    if visible
      $scope.comp.add = true
    else $scope.comp.add = false
    return

  $scope.addCompetitor = ->
    if $scope.newUserName != undefined and $scope.newUserSurname != undefined
      user =
        "name": $scope.newUserName
        "surname": $scope.newUserSurname
      $http.post("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/applicants", user).success (uid) ->
        user.id = uid.id
        $scope.competitors.push user
        $scope.newUserName = ""
        $scope.newUserSurname = ""
        $scope.comp.add = false
        return
      .error (data, status, headers, config) ->
        console.log status
        return
    #console.log $scope.newUserName, $scope.newUserSurname

    return false


  ###
  ============================ Настройки приложения ============================
  Загрузка настроек
  ###
  $http.get("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/settings").success (data) ->
    $scope.settings = data
    #$scope.settings.bgColors = ["#666"]
    if not $scope.settings.bgColors
      $scope.bgColors = ["666", "999", "eee"]
    else $scope.bgColors = $scope.settings.bgColors
    #$scope.bgColors = $scope.settings.bgColors ? $scope.settings.bgColors : ["#666", "#999", "#eee"]
     #= $scope.settings.bgColors
    return
  .error (data, status, headers, config) ->
    console.log status
    return

  ###
  Обновление паттерна
  ###
  $scope.updatePattern = (newpat) ->
    newPattern =
      "pattern": newpat
    $http.put("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/settings", newPattern).success (data) ->
      #$scope.settings.background = bg.background
      console.log "Паттерн обновлен"
      $scope.updPatternTxt = "Паттерн сохранен"
      return
    .error (data, status, headers, config) ->
      console.log status
      $scope.updPatternTxt = "Ошибка сохранения"
      return
    return

  $scope.updTxt = ->
    $scope.updPatternTxt = "Обновить"



  $scope.setBgColor = (bg) ->
    bg = "background": bg
    #console.log bg
    # Сохранить в настройках
    $http.put("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/settings", bg).success (data) ->
      $scope.settings.background = bg.background
      return
    .error (data, status, headers, config) ->
      console.log status
      return


  ###
  Добавляем новый цвет в палитру
  ###
  $scope.addBgColor = ->
    console.log $scope.bgColors
    if $scope.newColor.value != undefined
      $scope.bgColors.push( $scope.newColor.value );
      #console.log $scope.newColor.value
      $scope.newColor.value = ""
      bgColors = "bgColors": $scope.bgColors
      console.log bgColors
      $http.put("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/settings", bgColors).success (data) ->
        #$scope.settings.background = bg.background
        console.log "Цвета добавлены"

        return
      .error (data, status, headers, config) ->
        console.log status
        $scope.updPatternTxt = "Ошибка сохранения"
        return

    return

  ###
  Редактируем палитру (удаляем ненужные цвета)
  ###
  $scope.editPalette = (active) ->
    $scope.bgEdit.active = active
    #console.log $scope.bgColors
    return

  $scope.deleteColor = (event, index, color) ->
    console.log "index = #{index}"
    for key, value of $scope.bgColors
      console.log key, value
    event.stopPropagation()
    return

  ###
  Сбрасываем все настройки
  ###
  $scope.resetSettings = ->
    conf = confirm "Сбросить все настройки?"
    if conf
      $http.delete("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/settings").success (data) ->
        console.log "Настройки сброшены"
        return
      .error (data, status, headers, config) ->
        console.log "Ошибка при сбросе настроек"
        return
    return

  return