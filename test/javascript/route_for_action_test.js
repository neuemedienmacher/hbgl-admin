var assert = require('assert');
import { routeForAction } from '../../client/app/lib/routeForAction'

describe('routeForAction', function() {
  it('should return the correct edit path', function() {
    assert.equal(routeForAction('edit', 'Offer', 1), '/Offer/1/edit');
  });

  it('should return the correct show path', function() {
    assert.equal(routeForAction('show', 'Offer', 1), '/Offer/1');
  });

  it('should return the correct edit_assignable path', function() {
    assert.equal(routeForAction('edit_assignable', 'Offer', 1, 'OfferTranslation', 2), '/OfferTranslation/2/edit');
  });
});
