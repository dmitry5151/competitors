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
  $('#competitors').on 'change', ->
    $('#competitors tr:even').css background: '#ccc'
    return



  ###
  Таблица настроек - цвета ячеек
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
    return

  ###
= Создаем запрос ===============================================================
  ###
  competitor =
    "id": ""
    "name": "Черт"
    "surname": "Лесной"

#===============================================================================
  ###
  Ajax
  ###
  ajax = (uri, type, send) ->
    $.ajax
      crossDomain: true
      #headers: 'Content-Type: application/json'
      url: "http://applicants-tenet.rhcloud.com/api/1/dmitry5151#{uri}"
      type: type
      data: send
      success: (data) ->
        responce data
        return
    return

  ###
= Действия с пользователями ====================================================
  ###
  getUser = (id) -> # Передаем id пользователя, строим запрос, вызываем ajax

  deleteUser = (id) -> # Удаляем пользователя по id
    console.log "Удаление пользователя с id = #{id}"
    return

  updateUser = (id, name, surname) -> # Редактируем пользователя
    #console.log "Редактируем параметры: #{id}, #{name}, #{surname}"
    true

  activateUser = -> # Вешаем обработчик на загруженных пользователей

    $('.user-delete').on 'click', -> # Отрабатываем удаление
      uid = $(this).parent().parent().find('.user-id').text() # id пользователя
      deleteUser uid
      return

    $('.user-edit').on 'click', -> # Отрабатываем редактирование
      params = $(this).parent().parent(); # Строка с пользователем
      uid = params.find('.user-id').text()
      name = params.find('.user-name').text()
      surname = params.find('.user-surname').text()
      userEditStr = "" # Строка редактирования
      userEditStr = """
      <tr>
          <td></td>
          <td><input type="text" value="#{name}" /></td>
          <td><input type="text" value="#{surname}" /></td>
          <td><button class="save" type="button">Сохранить</button><button type="button">Отмена</button></td>
          <td></td>
      </tr>
      """
      params.after(userEditStr) # Вписываем строку редактирования
      params.hide() # Скрываем строку с пользователем

      res = ->
        $('.save').click ->
          updateUser uid, name, surname # Передача параметров и получение ответа
        return
      console.log res
      # Если ответ TRUE - скрываем редактирование и показываем обновленную строку
      # Если FALSE - выводим сообщение об ошибке
      return

    return
#===============================================================================
  ###
  Обработка ответа сервера
  ###
  responce = (data) ->
    user = ""
    for i in data
      user += """
      <tr>
          <td><img class="user-edit" src="img/user-edit.png" /></td>
          <td class="user-name">#{i.name}</td>
          <td class="user-surname">#{i.surname}</td>
          <td class="user-id">#{i.id}</td>
          <td><img class="user-delete" src="img/user-delete.png" /></td>
      </tr>
      """
    $('#competitors').append user
    do activateUser
    return

  ###
  Инициализируем приложение
  ###
  ajax '/applicants', 'GET', '' # Загружаем пользователей в таблицу



  return