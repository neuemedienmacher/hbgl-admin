const axios = require('axios');
const { expect } = require('chai');

const {
  BASE_URL,
  DEFAULT_RESPONSE_KEYS
} = require('./constants');
const { baseResponseExpectation } = require('./expectation-methods');
const { makeRequestWithValidCookie } = require('./login');


describe('v1 api routes', function() {
  this.timeout(5000);

  it('should get all cities', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/cities');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all areas', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/areas');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all offers', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/offers');

    baseResponseExpectation(res, [...DEFAULT_RESPONSE_KEYS, 'included']);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all contact people', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/contact-people');

    baseResponseExpectation(res, [...DEFAULT_RESPONSE_KEYS, 'included']);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all emails', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/emails');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all openings', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/openings');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all websites', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/websites');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all organization translations', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/organization-translations');

    baseResponseExpectation(res, [...DEFAULT_RESPONSE_KEYS, 'included']);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all offer translations', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/offer-translations');

    baseResponseExpectation(res, [...DEFAULT_RESPONSE_KEYS, 'included']);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all tags', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/tags');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all solution categories', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/solution-categories');

    baseResponseExpectation(res, [...DEFAULT_RESPONSE_KEYS, 'included']);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all assignments', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/assignments');

    baseResponseExpectation(res, [...DEFAULT_RESPONSE_KEYS, 'included']);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all definitions', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/definitions');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all federal states', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/federal-states');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all search locations', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/search-locations');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all language filters', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/language-filters');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all user teams', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/user-teams');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })

  it('should get all users', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/users');

    baseResponseExpectation(res);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  })
})


