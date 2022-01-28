const BASE_URL = 'http://localhost:3000';
const DEFAULT_RESPONSE_KEYS = ['data', 'meta', 'links'];
const DEBUG = Boolean(process.env.DEBUG) || false

module.exports = {
  BASE_URL,
  DEBUG,
  DEFAULT_RESPONSE_KEYS
}
