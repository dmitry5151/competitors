$ ->
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
      $(this).on('click', ->
        a.attr class: ''
        tab.hide()
        $(this).attr class: 'active'
        href = $(this).attr "href"
        $("div#" + href).css display: 'block'
        return false
      )
      return

    return

  return