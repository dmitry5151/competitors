manageCompetitors = angular.module 'manageCompetitors', []

manageCompetitors.controller 'compCtrl', ($scope, $http) ->
  $scope.work = "Приложение работает!"
  $scope.newColor = {}
  $scope.tab = {}

  #$scope.bgColorCurrent = $scope.settings.background

  #$scope.newColor = "#222"
  # Активация вкладок
  $scope.showTab = (num) -> # num - номер активируемой вкладки
    $scope.tab.number = num
    return

  ###
  Вкладки приложения
  ###
  $scope.tabs = [
    {tab: 1, name: "Соискатели", "class": "active", id: "tab-1", file: "competitors.html", show: true}
    {tab: 2, name: "Настройки", "class": "", id: "tab-2", file: "settings.html", show: false}
    {tab: 3, name: "Об авторе", "class": "", id: "tab-3", file: "author.html", show: false}
  ]

  ajax = (uri) ->

  ###
  Загрузка соискателей
  ###
  $http.get("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/applicants").success (data) ->
    $scope.competitors = data
    return

  ###
  Загрузка настроек
  ###
  $http.get("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/settings").success (data) ->
    $scope.settings = data
    return

  ###
  Цвета фонов (временно)
  ###
  $scope.bgColors = ["#666", "#999", "#eee"]

  $scope.setBgColor = (bg) ->
    bg = "background": bg
    #console.log bg
    # Сохранить в настройках
    $http.put("http://applicants-tenet.rhcloud.com/api/1/dmitry5151/settings", bg).success (data) ->
      $scope.settings.background = bg.background


  $scope.addBgColor = ->
    if $scope.newColor.value != undefined
      $scope.bgColors.push( $scope.newColor.value );
      #console.log $scope.newColor.value
      $scope.newColor.value = ""

    return

  #console.log $scope.newColor
  return