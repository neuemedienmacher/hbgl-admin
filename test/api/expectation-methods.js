const { expect } = require('chai')
const {
  DEFAULT_RESPONSE_KEYS
} = require('./constants');

const baseResponseExpectation = (res, expectedKeys = DEFAULT_RESPONSE_KEYS) => {
    expect(res.status).to.equal(200);
    expect(res.data).to.include.all.keys(...expectedKeys);
    expect(res.data.links).to.include.all.keys('previous', 'next');
    expect(res.data.meta).to.include.all.keys('total_entries', 'per_page', 'total_pages', 'current_page');
}

module.exports = {
  baseResponseExpectation
}
