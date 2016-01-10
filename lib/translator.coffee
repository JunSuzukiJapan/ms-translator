http = require('http')
https = require('https')
qs = require('querystring')

module.exports = class Translator

  constructor: (@client_id, @client_secret) ->
    #console.log('constructor')

  getAccessToken: (callback) ->
    #console.log('expire ', Translator.expire_msec, 'now', Date.now())
    if Translator.expire_msec > Date.now() && Translator.token
      callback(Translator.token)
      return

    options = {
      host: 'datamarket.accesscontrol.windows.net'
      path: '/v2/OAuth2-13'
      method: 'POST'
    }

    req = https.request options, (res) ->
      body = ''
      res.setEncoding('utf8');
      res.on 'data', (chunk) ->
        body += chunk
      res.on 'end', ->
        resData = JSON.parse(body)
        #console.log('resDate ', resData)
        expires = resData.expires_in
        Translator.expire_msec = Date.now() + ((expires - 5) * 1000)
        Translator.token = resData.access_token
        callback(Translator.token)

    req.on 'error', (err) ->
      console.log(err)

    data = {
      'client_id': @client_id
      'client_secret': @client_secret
      'scope': 'http://api.microsofttranslator.com'
      'grant_type': 'client_credentials'
    }

    req.write(qs.stringify(data))
    req.end()

  translate: (token, text, from_lang, to_lang, callback) ->
    options = "text=" + qs.escape(text) +
              "&from=" + from_lang +
              "&to=" + to_lang +
              "&oncomplete=callback"

    request_options =
      host: 'api.microsofttranslator.com'
      path: '/V2/Ajax.svc/Translate?' + options
      method: 'GET'
      headers:
        "Authorization": 'Bearer ' + token

    req = https.request request_options, (res) ->
      body = ''
      res.setEncoding('utf8')
      res.on 'data', (chunk) ->
        body += chunk
      res.on 'end', ->
        # body の中身は "callback(translated_text)"　という形になっているはず。
        text = body.replace('callback("', '').replace(/"\);$/, '')
        callback(text)

    req.on 'error', (e) ->
      console.log(e.message)
    req.end()
