const { expect } = require('chai');
const faker = require('faker');
const { baseResponseExpectation } = require('./expectation-methods');
const { BASE_URL, DEFAULT_RESPONSE_KEYS } = require('./constants');
const { makeRequestWithValidCookie, extractCsrfTokenAndCookie } = require('./login');


const locationPayload = {
  "data": {
    "type": "cities",
    "attributes": {
      "name": faker.address.streetAddress()
    }
  },
  "meta":{"utf8":"✓"}
}

let createdCityId;

describe('v1 api routes: locations', function() {
  this.timeout(10000);

  it('should get all locations', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/locations');

    baseResponseExpectation(res, [...DEFAULT_RESPONSE_KEYS]);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  });

  it('should get location with id = 1', async function() {
    const id = '1';

    const res = await makeRequestWithValidCookie(`/api/v1/locations/${id}`);

    expect(res.data).to.have.all.keys('data', 'included');
    const { data } = res.data
    expect(data).to.have.all.keys('id','attributes','type', 'relationships');
    expect(data.id).to.equal(id);
  });

  it('should query locations with a search string', async function() {
    const searchString = 'Kassel';

    const res = await makeRequestWithValidCookie(`/api/v1/locations?query=${searchString}`);

    console.log(JSON.stringify(res.data, null, 2));
    expect(res.data).to.have.all.keys('data', 'included', 'links', 'meta');
    expect(res.data.data).to.be.not.empty;
  });

  it('should query locations with a search string when organisation isnt created yet', async function() {
    const searchString = 'Kassel';

    const res = await makeRequestWithValidCookie(`/api/v1/locations?query=${searchString}&filters%5Borganization_id%5D=nil&operators%5Binterconnect%5D=OR`);

    expect(res.data.data).to.be.not.empty;
  });


  it.skip('should create a location', async function() {
    const { csrf, cookie } = await extractCsrfTokenAndCookie(`${BASE_URL}/cities/new`)
    const res = await makeRequestWithValidCookie(`/api/v1/cities`, 'post', locationPayload, { cookie, csrf });

    expect(res.status).to.equal(201);
    expect(res.data).to.be.not.empty;
    expect(res.data.data).to.be.not.empty;
    const { data } = res.data;
    expect(Number(data.id)).to.be.above(0);
    expect(data.type).to.equal('cities');
    expect(data.attributes).to.have.all.keys('name','label','created-at','updated-at');
    createdCityId = data.id;
  });

  it.skip('should delete a location', async function() {
    const { csrf, cookie } = await extractCsrfTokenAndCookie(`${BASE_URL}/cities/${createdCityId}`)
    const res = await makeRequestWithValidCookie(`/api/v1/cities/${createdCityId}`, 'delete', {}, { csrf, cookie });

    expect(res.status).to.equal(200);
  });
});
