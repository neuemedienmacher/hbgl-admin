var assert = require('assert');
import moment from 'moment'
import { getTimePointsBetween } from '../../client/app/lib/timeUtils'

describe('getTimePointsBetween', function() {
  it('should return one step when end-date equals start-date', function() {
    const start_date = moment();
    const end_date = moment();
    let result = getTimePointsBetween(start_date, end_date, 'day')
    assert.equal(result.length, 1);
  });

  it('should return no steps at all for end_date < start_date', function() {
    const start_date = moment();
    const end_date = moment().subtract(5, 'days');
    let result = getTimePointsBetween(start_date, end_date, 'day')
    assert.equal(result.length, 0);
  });

  it('should return 8 day-steps for a week', function() {
    const start_date = moment().subtract(7, 'days');
    const end_date = moment();
    let result = getTimePointsBetween(start_date, end_date, 'day')
    assert.equal(result.length, 8);
  });

  it('should return 13 month-steps for a year', function() {
    const start_date = moment().subtract(1, 'year');
    const end_date = moment();
    let result = getTimePointsBetween(start_date, end_date, 'month')
    assert.equal(result.length, 13);
  });
});
