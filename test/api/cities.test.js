const { expect } = require('chai');
const faker = require('faker');
const { baseResponseExpectation } = require('./expectation-methods');
const { BASE_URL, DEFAULT_RESPONSE_KEYS } = require('./constants');
const { makeRequestWithValidCookie, extractCsrfTokenAndCookie } = require('./login');


const cityPayload = {
  "data": {
    "type": "cities",
    "attributes": {
      "name": faker.address.city()
    }
  },
  "meta":{"utf8":"✓"}
}

let createdCityId;

describe('v1 api routes: cities', function() {
  this.timeout(10000);

  it('should get all cities', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/cities');

    baseResponseExpectation(res, [...DEFAULT_RESPONSE_KEYS]);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  });

  it('should get city with id = 1', async function() {
    const id = '1';

    const res = await makeRequestWithValidCookie(`/api/v1/cities/${id}`);

    expect(res.data).to.have.all.keys('data');
    const { data } = res.data
    expect(data).to.have.all.keys('id','attributes','type');
    expect(data.id).to.equal(id);
  });

  it('should create a city', async function() {
    const { csrf, cookie } = await extractCsrfTokenAndCookie(`${BASE_URL}/cities/new`)
    const res = await makeRequestWithValidCookie(`/api/v1/cities`, 'post', cityPayload, { cookie, csrf });

    expect(res.status).to.equal(201);
    expect(res.data).to.be.not.empty;
    expect(res.data.data).to.be.not.empty;
    const { data } = res.data;
    expect(Number(data.id)).to.be.above(0);
    expect(data.type).to.equal('cities');
    expect(data.attributes).to.have.all.keys('name','label','created-at','updated-at');
    createdCityId = data.id;
  });

  it('should delete a city', async function() {
    const { csrf, cookie } = await extractCsrfTokenAndCookie(`${BASE_URL}/cities/${createdCityId}`)
    const res = await makeRequestWithValidCookie(`/api/v1/cities/${createdCityId}`, 'delete', {}, { csrf, cookie });

    expect(res.status).to.equal(200);
  });
});
