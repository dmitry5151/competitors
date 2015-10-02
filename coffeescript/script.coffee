$ ->
  ###
  Всплытие/скрытие формы
  ###
  overlay = $('.overlay')
  $('.add').click (event) ->
    do event.stopPropagation # Запрещаем всплытие события выше текущего элемента при клике в его поле
    return

  overlay.click ->
    overlay.hide()
    return

  $('#show-form').click ->
    overlay.show()
    $('#new-user-name').focus().val("")
    $('#new-user-surname').val("")
    return

  $('#cansel').click ->
    overlay.hide()
    return

  ###
  Управление табами
  ###
  tabs = $('.tab-container')
  tabs.each ->
    a = $(this).find('ul.tabs a')
    tab = $(this).find('div.tabs-content>div')
    active = $(this).find('ul.tabs a.active').length
    if active is 0
      # Нет активных ссылок, активируем самую первую вкладку
      firstTab = $(this).find('ul.tabs li:first-child a')
      firstTab.attr class: 'active'
      href = firstTab.attr "href"
      $("div#" + href).css display: 'block'

    a.each ->
      $(this).on 'click', ->
        a.attr class: ''
        tab.hide()
        $(this).attr class: 'active'
        href = $(this).attr "href"
        $("div#" + href).css display: 'block'
        return false

      return

    return
  ###
  Таблица соискателей - стили, управление строками
  ###
  striped = ->
    $('#competitors tr:even').css background: '#ccc'
    return



  ###
=================== Таблица настроек - цвета ячеек =============================
  ###
  bg = $('html');
  curBg = bg.css 'background-color'
  cells = $('.color-settings td').not('.caption')

  $('#color1').css 'background-color': "#666"
  $('#color2').css 'background-color': "#999"
  $('#color3').css 'background-color': "#eee"

  $('#color1').on 'mouseover', ->
    bg.css 'background-color': '#666'
    return
  .on 'mouseout', ->
    bg.css 'background-color': curBg
    return
  .on 'click', ->
    curBg = '#666'
    cells.text('')
    $(this).text("Текущий")
    set =
      "background": "#666"
      "curID": "#color1"
    ajax '6', '/settings', 'PUT', set
    return

  $('#color2').on 'mouseover', ->
    bg.css 'background-color': '#999'
    return
  .on 'mouseout', ->
    bg.css 'background-color': curBg
    return
  .on 'click', ->
    curBg = '#999'
    cells.text('')
    $(this).text("Текущий")
    set =
      "background": "#999"
      "curID": "#color2"
    ajax '6', '/settings', 'PUT', set
    return

  $('#color3').on 'mouseover', ->
    bg.css 'background-color': '#eee'
    return
  .on 'mouseout', ->
    bg.css 'background-color': curBg
    return
  .on 'click', ->
    curBg = '#eee'
    cells.text('')
    $(this).text("Текущий")
    set =
      "background": "#eee"
      "curID": "#color3"
    ajax '6', '/settings', 'PUT', set
    return

  ###
= Настройки приложения =========================================================
  ###

  # Сохранение паттерна
  $('form.settings').on 'submit', ->
    # ^[А-Я][а-я-]+[а-я]$
    patVal = $('#pattern').val().trim() # обрезать окружающие слэши при наличии
    #console.log patVal.length
    if patVal.charAt(0) == "/"
      patVal = patVal.slice(1);
    if patVal.charAt(patVal.length - 1) == "/"
      patVal = patVal.slice(0, patVal.length - 1);
    setting =
      "setting": "pattern"
    newPattern = "pattern": patVal
    ajax '6', '/settings', 'PUT', newPattern, setting
    return false

  # Сброс всех настроек
  $('#resetSettings').on 'click', ->
    resSet = confirm "Сбросить все настройки?"
    if resSet
      ajax '7', '/settings', 'DELETE'
    return

  # Загрузка настроек
  loadSettings = (data) ->

    # Установки фона
    $('html').css 'background-color': data.background
    curBg = data.background
    $('.color-settings td').not('.caption').text('')
    $(".color-settings td#{data.curID}").text("Текущий")

    # Паттерн для имени-фамилии
    $("#pattern-show").text(data.pattern)

    console.log data
    return

  updateSettings = (data) ->
    if data
      switch data.setting
        when "pattern"
          pv = $('#pattern').val()
          if pv.charAt(0) == "/"
            pv = pv.slice(1);
          if pv.charAt(pv.length - 1) == "/"
            pv = pv.slice(0, pv.length - 1);
          $('#saveSettings').val "Сохранено"
          $('#pattern-show').text pv
          #console.log data.pattern
        else return
    else console.log "Нет доп. настроек"
    return

#===============================================================================
  ###
  Ajax
  ###
  ajax = (flag, uri, type, send, elem) ->
    $.ajax
      crossDomain: true
      #headers: 'Content-Type: application/json'
      url: "http://applicants-tenet.rhcloud.com/api/1/dmitry5151#{uri}"
      type: type
      data: send
      error: (xhr, msg) ->
        #alert xhr.status
      statusCode:
        400: ->
          alert "Ошибка выполнения ajax запроса!"
          #do addUserError
          return
      success: (data) ->
        #responce data
        switch flag
          when "0" then showUsers data
          when "1" then addUser data, send
          when "2" then updateUser elem
          when "3" then deleteUser elem
          when "4" then deleteAllUsers data
          when "5" then loadSettings data # Загрузка настроек
          when "6" then updateSettings elem # Обновление настроек
        return
    return

  ###
= Действия с пользователями ====================================================
  ###

  showUsers = (data) ->
    user = ""
    for i in data
      user += """
      <tr>
          <td><img class="user-edit" src="img/user-edit.png" /></td>
          <td class="user-name">#{i.name}</td>
          <td class="user-surname">#{i.surname}</td>
          <td class="user-id">#{i.id}</td>
          <td><img title="Удалить соискателя" class="user-delete" src="img/user-delete.png" /></td>
      </tr>
      """
    $('#competitors').append user
    do striped # Раскрашиваем строки
    do activateUsers
    return

  getUser = (id) -> # Передаем id пользователя, строим запрос, вызываем ajax

  # Соискатель удален, убираем строку
  deleteUser = (elem) ->
    console.log "Соискатель успешно удален"
    elem.slideUp().remove()
    do striped # Раскрашиваем строки
    return

  # Редактируем пользователя
  updateUser = (data) ->
    data.uetr.remove()
    data.tr.show()
    console.log "Сохранено"
    # Перезагружаем пользователей
    $('#competitors tr:not(:first-child)').remove()
    ajax '0', '/applicants', 'GET', ''
    #do activateUsers
    return

  # Добавляем соискателя
  $('#new-user').submit -> # Добавить валидацию по паттерну
    newUserName = $('#new-user-name').val()
    newUserSurname = $('#new-user-surname').val()
    # Проверяем на соответствие шаблону, исправляем заглавную букву в начале
    pattern = new RegExp $("#pattern-show").text()
    if (pattern.test newUserName) and (pattern.test newUserSurname)
      console.log "Шаблон прошел провеку"
      newUser =
        "name" : newUserName
        "surname" : newUserSurname
      ajax '1', '/applicants', 'POST', newUser
    else
      console.log "Проверка не пройдена"
      alert "Имя или фамилия введены некорректно!"
    false

  addUser = (data, newUserData) ->
    newUserStr = """
    <tr>
        <td><img class="user-edit" src="img/user-edit.png" /></td>
        <td class="user-name">#{newUserData.name}</td>
        <td class="user-surname">#{newUserData.surname}</td>
        <td class="user-id">#{data.id}</td>
        <td><img title="Удалить соискателя" class="user-delete" src="img/user-delete.png" /></td>
    </tr>
    """

    $('#competitors').append newUserStr
    do striped # Раскрашиваем строки
    do activateUsers

    # Закрываем или не закрываем окно
    if not $('#multiAdd').prop("checked")
      overlay.hide()
    else
      $('#new-user-name').focus().val("")
      $('#new-user-surname').val("")
    return

  activateUsers = -> # Вешаем обработчик на загруженных пользователей

    # Обнуляем обработчики (нужно при добавлении нового соискателя)
    $('.user-delete').off()
    $('.user-edit').off()

    # Отрабатываем удаление
    $('.user-delete').on 'click', ->
      deleteThisUser = confirm "Вы уверены, что хотите удалить соискателя?"
      if deleteThisUser
        elem = $(this).parent().parent() # строка с соискателем
        uid = elem.find('.user-id').text() # id пользователя
        #deleteUser uid, elem
        ajax '3', "/applicants/#{uid}", 'DELETE', '', elem
      return

    # Отрабатываем редактирование
    $('.user-edit').on 'click', ->
      params = $(this).parent().parent(); # Строка с пользователем
      uid = params.find('.user-id').text()
      name = params.find('.user-name').text()
      surname = params.find('.user-surname').text()
      userEditStr = "" # Строка редактирования
      userEditStr = """
      <tr id="edit">
          <td></td>
          <td><input class="user-edit-name" type="text" value="#{name}" /></td>
          <td><input class="user-edit-surname" type="text" value="#{surname}" /></td>
          <td><button class="user-edit-save" type="button">Сохранить</button><button class="user-edit-cansel" type="button">Отмена</button></td>
          <td></td>
      </tr>
      """
      params.after(userEditStr) # Вписываем строку редактирования
      params.hide() # Скрываем строку с пользователем

      userEditTr = params.next() # Выбираем нужную строку редактирования

      # Вешаем обработчик на строку редактирования
      editName = userEditTr.find('.user-edit-name')
      editSurname = userEditTr.find('.user-edit-surname')
      editCansel = userEditTr.find('.user-edit-cansel')
      editSave = userEditTr.find('.user-edit-save')

      editCansel.on 'click', ->
        userEditTr.remove()
        params.show()
        return

      editSave.on 'click', ->
        update =
          "name": editName.val()
          "surname": editSurname.val()
        data =
          "uetr": userEditTr
          "tr": params
        ajax '2', "/applicants/#{uid}", 'PUT', update, data
        return

      # Если ответ TRUE - скрываем редактирование и показываем обновленную строку
      # Если FALSE - выводим сообщение об ошибке
      return

    return

  # Удаляем всех соискателей
  $('#users-delete-all').on 'click', ->
    deleteAll = confirm "Вы уверены, что хотите очистить список соискателей?"
    if deleteAll
      ajax '4', '/applicants', 'DELETE', ''
    return

  deleteAllUsers = (data) ->
    # После удаления возвращается undefined
    $('#competitors tr:not(:first-child)').remove()
    console.log "Успешное удаление"

  ###
= Инициализируем приложение ====================================================
  ###

  # Загружаем имеющихся соискателей в таблицу
  ajax '0', '/applicants', 'GET'

  # Загружаем настройки
  ajax '5', '/settings', 'GET'

  return

###
Значения флагов ajax запросов

0 - Начальная загрузка всех пользователей, имеющихся в базе
1 - Добавление нового соискателя
2 - Редактирование соискателя
3 - Удаление соискателя
4 - Удаление всех соискателей
5 - Загрузка настроек
6 - Обновление настроек
7 - Сброс настроек
###