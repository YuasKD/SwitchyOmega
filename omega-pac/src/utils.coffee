Revision =
  fromTime: (time) ->
    time = if time then new Date(time) else new Date()
    return time.getTime().toString(16)
  compare: (a, b) ->
    return 0 if not a and not b
    return -1 if not a
    return 1 if not b
    return 1 if a.length > b.length
    return -1 if a.length < b.length
    return 1 if a > b
    return -1 if a < b
    return 0

exports.Revision = Revision

class AttachedCache
  constructor: (opt_prop, @tag) ->
    @prop = opt_prop
    if typeof @tag == 'undefined'
      @tag = opt_prop
      @prop = '_cache'
  get: (obj, otherwise) ->
    tag = @tag(obj)
    cache = @_getCache(obj)
    if cache? and cache.tag == tag
      return cache.value
    value = if typeof otherwise == 'function' then otherwise() else otherwise
    @_setCache(obj, {tag: tag, value: value})
    return value
  drop: (obj) ->
    if obj[@prop]?
      obj[@prop] = undefined
  _getCache: (obj) -> obj[@prop]
  _setCache: (obj, value) ->
    if not Object::hasOwnProperty.call obj, @prop
      Object.defineProperty obj, @prop, writable: true
    obj[@prop] = value

exports.AttachedCache = AttachedCache

exports.getBaseDomain = (domain) ->
  return domain if domain.indexOf(':') > 0 # IPv6
  lastCharCode = domain.charCodeAt(domain.length - 1)
  return domain if 48 <= lastCharCode <= 57 # IP address ending with number.
  segments = domain.split('.')
  if segments.length <= 2
    return domain
  if segments[0] == 'www'
    segments.shift()
  len = segments.length
  if len <= 2
    return segments.join('.')
  if segments[len - 2].length <= 2
    return segments[len - 3] + '.' + segments[len - 2] + '.' + segments[len - 1]
  else
    return segments[len - 2] + '.' + segments[len - 1]
