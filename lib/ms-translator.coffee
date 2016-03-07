MsTranslatorView = require './ms-translator-view'
{CompositeDisposable} = require 'atom'
Translator = require './translator'

module.exports = MsTranslator =
  msTranslatorView: null
  modalPanel: null
  subscriptions: null
  translator: null
  translatedText: null

  config:
    client_id:
      type: 'string'
      default: 'Your client id'
    client_secret:
      type: 'string'
      default: 'Your client secret'

  activate: (state) ->
    @msTranslatorView = new MsTranslatorView(state.msTranslatorViewState)
    @modalPanel = atom.workspace.addBottomPanel(item: @msTranslatorView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'ms-translator:run': => @run()
    @subscriptions.add atom.commands.add 'atom-workspace', 'ms-translator:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'ms-translator:paste': => @paste()

    @client_id = atom.config.get('ms-translator.client_id')
    @client_secret = atom.config.get('ms-translator.client_secret')
    #console.log('client_id', @client_id, 'client_secret', @client_secret)
    @translator = new Translator(@client_id, @client_secret)

  deactivate: ->
    console.log('deactivate')
    @modalPanel.destroy()
    @subscriptions.dispose()
    @msTranslatorView.destroy()

  serialize: ->
    msTranslatorViewState: @msTranslatorView.serialize()

  toggle: ->
    #console.log 'MsTranslator was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  setText: (text) ->
    @translatedText = text
    @msTranslatorView.setText(text)
    @modalPanel.show()

  paste: ->
    return if @translatedText == null

    editor = atom.workspace.getActiveTextEditor()
    if editor
      editor.insertText @translatedText



  run: ->
    @translatedText = null
    lang = @msTranslatorView.getLaunguages()
    #console.log('lang ', lang)
    from = lang.from
    to = lang.to
    self = this
    #console.log('run')
    # 現在開いているeditorの本体
    editor = atom.workspace.getActiveTextEditor()
    if editor

#      @client_id = atom.config.get('ms-translator.client_id')
#      @client_secret = atom.config.get('ms-translator.client_secret')
#      console.log('client_id', @client_id, 'client_secret', @client_secret)
#      translator = new Translator(@client_id, @client_secret)

      text = editor.getSelectedText()
      console.log('selected: ', text)
      if !text || text.length == 0
        self.setText('<<no selection>>')
        return

      this.setText('...')
      self.translator.getAccessToken (token) ->
#        from = 'en'
#        to =  'ja'
        self.translator.translate token, text, from, to, (translated) ->
          console.log(translated)
          self.setText(translated)
