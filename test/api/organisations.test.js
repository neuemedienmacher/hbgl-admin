const { expect } = require('chai');
const faker = require('faker');
const { baseResponseExpectation } = require('./expectation-methods');
const { BASE_URL, DEFAULT_RESPONSE_KEYS } = require('./constants');
const { makeRequestWithValidCookie, extractCsrfTokenAndCookie } = require('./login');

const organizationPayload = {
  "data": {
    "type": "organizations",
    "attributes": {
      "name": faker.lorem.word(),
      "description": null,
      "comment": null,
      "priority": false,
      "pending-reason": ""
    },
    "relationships": {
      "website": {
        "data": {
          "id": "11915",
          "type": "websites"
        }
      },
      "divisions": {},
      "locations": {
        "data": [{ "id": "4990", "type": "locations" }]
      },
      "contact-people": {},
      "topics": {}
    }
  },
  "meta": { "utf8": "✓" }
}

const organizationWithNewLocation = {
  "data": {
    "type": "organizations",
    "attributes": {
      "name": `Codebuero ${faker.datatype.number()}`,
      "description": null,
      "comment": null,
      "priority": false,
      "pending-reason": ""
    },
    "relationships": {
      "website": {
        "data": {
          "id": "6207",
          "type": "websites"
        }
      },
      "divisions": {},
      "locations": {
        "data": [{
          "type": "locations",
          "attributes": {
            "name": "codebuero hq",
            "street": "scherer str. 6",
            "addition": null,
            "zip": "13347",
            "hq": true,
            "visible": true,
            "in-germany": true
          },
          "relationships": {
            "city": {
              "data": {
                "id": "1"
              }
            },
            "federal-state": {
              "data": {
                "id": "2"
              }
            },
            "organization": {}
          }
        }]
      },
      "contact-people": {},
      "topics": {}
    }
  },
  "meta": {
    "utf8": "✓"
  }
}


describe.only('v1 api routes: organizations', function() {
  this.timeout(10000);

  it('should get all organizations', async function() {
    const res = await makeRequestWithValidCookie('/api/v1/organizations');

    baseResponseExpectation(res, [...DEFAULT_RESPONSE_KEYS, 'included']);
    expect(res.data.data).to.be.instanceof(Array);
    expect(res.data.data.length).to.be.above(0);
  });

  it('should get organization with id = 1', async function() {
    const id = '1';

    const res = await makeRequestWithValidCookie(`/api/v1/organizations/${id}`);

    expect(res.data).to.have.all.keys('data', 'included');
    const { data } = res.data
    expect(data).to.have.all.keys('id', 'attributes', 'relationships', 'type', 'links');
    expect(data.id).to.equal(id);
  });

  it.skip('should create a new organization with existing website & location', async function() {
    const { csrf, cookie } = await extractCsrfTokenAndCookie(`${BASE_URL}/organizations/new`);
    const res = await makeRequestWithValidCookie(`/api/v1/organizations`, 'post', organizationPayload, { cookie, csrf });

    expect(res.status).to.equal(201);
  });

  it('should create a new organization with existing website & new location', async function() {
    const { csrf, cookie } = await extractCsrfTokenAndCookie(`${BASE_URL}/organizations/new`);
    const res = await makeRequestWithValidCookie(`/api/v1/organizations`, 'post', organizationWithNewLocation, { cookie, csrf });

    expect(res.status).to.equal(201);
  });
});
