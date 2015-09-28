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
  tab = $('#competitors')
  $('#competitors tr:even').css background: '#ccc'



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
  Создаем запрос
  ###
  competitor =
    "id": ""
    "name": "Черт"
    "surname": "Лесной"

  $('#take').on 'click', ->
    ajax '/applicants', 'GET', ''
    return

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
  Обработка ответа сервера
  ###
  responce = (data) ->
    user = ""
    for i in data
      user += """
      <tr>
          <td></td>
          <td>#{i.name}</td>
          <td>#{i.surname}</td>
          <td>#{i.id}</td>
      </tr>
      """
    $('#competitors').append user
    return

  return