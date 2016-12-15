export function pluralize(string) {
  const rules = [
    [ /(quiz)$/i, '$1zes' ],
    [ /^(oxen)$/i, '$1' ],
    [ /^(ox)$/i, '$1en' ],
    [ /^(m|l)ice$/i, '$1ice' ],
    [ /^(m|l)ouse$/i, '$1ice' ],
    [ /(matr|vert|ind)(?:ix|ex)$/i, '$1ices' ],
    [ /(x|ch|ss|sh)$/i, '$1es' ],
    [ /([^aeiouy]|qu)y$/i, '$1ies' ],
    [ /(hive)$/i, '$1s' ],
    [ /(?:([^f])fe|([lr])f)$/i, '$1$2ves' ],
    [ /sis$/i, 'ses' ],
    [ /([ti])a$/i, '$1a' ],
    [ /([ti])um$/i, '$1a' ],
    [ /(buffal|tomat)o$/i, '$1oes' ],
    [ /(bu)s$/i, '$1ses' ],
    [ /(alias|status)$/i, '$1es' ],
    [ /(octop|vir)i$/i, '$1i' ],
    [ /(octop|vir)us$/i, '$1i' ],
    [ /^(ax|test)is$/i, '$1es' ],
    [ /s$/, 's' ],
    [ /$/, 's' ],
  ]

  for (let [rule, replacement] of rules) {
    if (string.match(rule))
      return string.replace(rule, replacement)
  }
  return string
}
