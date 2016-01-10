module.exports =
class MsTranslatorView
  @languages:
    "ar": "Arabic"
    "bs-Latn": "Bosnian (Latin)"
    "bg": "Bulgarian"
    "ca": "Catalan"
    "zh-CHS": "Chinese Simplified"
    "zh-CHT": "Chinese Traditional"
    "hr": "Croatian"
    "cs": "Czech"
    "da": "Danish"
    "nl": "Dutch"
    "en": "English"
    "et": "Estonian"
    "fi": "Finnish"
    "fr": "French"
    "de": "German"
    "el": "Greek"
    "ht": "Haitian Creole"
    "he": "Hebrew"
    "hi": "Hindi"
    "mww": "Hmong Daw"
    "hu": "Hungarian"
    "id": "Indonesian"
    "it": "Italian"
    "ja": "Japanese"
    "sw": "Kiswahili"
    "tlh": "Klingon"
    "tlh-Qaak": "Klingon (pIqaD)"
    "ko": "Korean"
    "lv": "Latvian"
    "lt": "Lithuanian"
    "ms": "Malay"
    "mt": "Maltese"
    "no": "Norwegian"
    "fa": "Persian"
    "pl": "Polish"
    "pt": "Portuguese"
    "otq": "Querétaro Otomi"
    "ro": "Romanian"
    "ru": "Russian"
    "sr-Cyrl": "Serbian (Cyrillic)"
    "sr-Latn": "Serbian (Latin)"
    "sk": "Slovak"
    "sl": "Slovenian"
    "es": "Spanish"
    "sv": "Swedish"
    "th": "Thai"
    "tr": "Turkish"
    "uk": "Ukrainian"
    "ur": "Urdu"
    "vi": "Vietnamese"
    "cy": "Welsh"
    "yua": "Yucatec Maya"

  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('ms-translator')

    # Create message element
    message = document.createElement('div')
    message.textContent = ''
    message.classList.add('message')
    @element.appendChild(message)

    @selectFrom = document.createElement('select')
    @selectFrom.setAttribute('name', 'from')

    @selectTo = document.createElement('select')
    @selectTo.setAttribute('name', 'to')

    defaultFrom = 'en'
    defaultTo = 'ja'
    for key, value of MsTranslatorView.languages
      option = document.createElement('option')
      if key == defaultFrom
        option.setAttribute('selected', null)
      option.setAttribute('value', key)
      text = document.createTextNode(value)
      option.appendChild(text)
      @selectFrom.appendChild(option)

      option = document.createElement('option')
      if key == defaultTo
        option.setAttribute('selected', null)
      option.setAttribute('value', key)
      text = document.createTextNode(value)
      option.appendChild(text)
      @selectTo.appendChild(option)

    div = document.createElement('div')
    text = document.createTextNode('translate from ')
    div.appendChild(text)
    div.appendChild(@selectFrom)

    text = document.createTextNode('   to ')
    div.appendChild(text)
    div.appendChild(@selectTo)
    @element.appendChild(div)

  getLaunguages: ->
    from = @selectFrom.children[@selectFrom.selectedIndex]
    to   = @selectTo.children[@selectTo.selectedIndex]
    {
      from: from.value
      to: to.value
    }

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setText: (text) ->
    @element.children[0].textContent = text
