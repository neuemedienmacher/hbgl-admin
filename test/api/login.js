const FormData = require('form-data');
const axios = require('axios');
const cheerio = require('cheerio');
const { expect } = require('chai');

const { BASE_URL, DEBUG } = require('./constants');

let CSRF_TOKEN = '';
let COOKIE = '';

const extractCookie = (headerCookie) => {
  const _c = headerCookie[0].split(';')[0];
  return _c
}

const validateStatus =  function (status) {
  return status >= 200 && status < 400;
};

const extractCsrfTokenAndCookie = async (url, cookie = COOKIE) => {
  const res = await axios.get(url, { headers: { cookie }});
  const $ = cheerio.load(res.data);
  let csrf = $('form input[name="authenticity_token"]').attr('value');
  const newCookie = extractCookie(res.headers['set-cookie']);

  if (!csrf) {
    const serverDataInScriptTag = $('.js-react-on-rails-component').html();
    const props = JSON.parse(serverDataInScriptTag)
    csrf = props.props.authToken
  }

  (DEBUG) ? console.log('found csrf: ', csrf) : ''

  return {
    csrf,
    cookie: newCookie
  }
}

const getWorkingCookie = async () => {
  const { csrf, cookie } = await extractCsrfTokenAndCookie(`${BASE_URL}/`, COOKIE);
  CSRF_TOKEN = csrf;
  COOKIE = cookie;
  const form = new FormData();

  //form.append('utf8','✓');
  form.append('authenticity_token', CSRF_TOKEN);
  form.append('user[email]', 'andreas.rotter.kontakt@googlemail.com');
  form.append('user[password]', 'password');

  const login = await axios.post(`${BASE_URL}/users/sign_in`, form, { validateStatus, maxRedirects: 0,headers: { ...form.getHeaders(), cookie: COOKIE }});
  expect(login.status).to.equal(302);
  COOKIE = extractCookie(login.headers['set-cookie']);
}

const makeRequestWithValidCookie = async (path, method = 'get', data = {}, tokens = { cookie: '', csrf: ''}) => {
  if (!COOKIE) {
    await getWorkingCookie();
  }

  const res = await axios({
    url: `${BASE_URL}${path}`,
    method,
    data,
    validateStatus,
    headers: { cookie: tokens.cookie || COOKIE, "X-CSRF-TOKEN": tokens.csrf || CSRF_TOKEN },
  });

  COOKIE = extractCookie(res.headers['set-cookie']);
  return res
}

module.exports = {
  extractCsrfTokenAndCookie,
  makeRequestWithValidCookie
}
