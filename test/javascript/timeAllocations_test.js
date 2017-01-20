var assert = require('assert');
import { getAllocationForWeekAndUser }
  from '../../client/app/lib/timeAllocations'

describe('getAllocationForWeekAndUser', function() {
  it('should return nothing when the user_id does not match', function() {
    let timeAllocationInput = [{user_id: 1}]
    let result = getAllocationForWeekAndUser(timeAllocationInput, 1, 2016, 2)
    assert.equal(result[0], false);
    assert.equal(result[1], false);
    assert.equal(result[2].desired_wa_hours, 0);
    assert.equal(result[2].actual_wa_hours, null);
    assert.equal(result[2].year, 2016);
    assert.equal(result[2].week_number, 1);
    assert.equal(result[2].user_id, 2);
  });

  it('should return the time_allocation if it already exists', function() {
    let timeAllocationInput = [
      {
        user_id: 1,
        week_number: 1,
        year: 2016,
        desired_wa_hours: 8,
        actual_wa_hours: 7
      }
    ]
    // call for different user => no results
    let result = getAllocationForWeekAndUser( timeAllocationInput, 1, 2016, 2)
    assert.equal(result[0], false);

    // call with correct user_id in order to find old time allocations
    result = getAllocationForWeekAndUser( timeAllocationInput, 1, 2016, 1)
    assert.equal(result[0], true);
    assert.equal(result[1], false);
    assert.equal(result[2].desired_wa_hours, 8);
    assert.equal(result[2].actual_wa_hours, 7);
    assert.equal(result[2].year, 2016);
    assert.equal(result[2].week_number, 1);
    assert.equal(result[2].user_id, 1);
  });

  it('returns closest timeAllocation when more than one exist', function() {
    let timeAllocationInput = [
      {
        user_id: 1,
        week_number: 1,
        year: 2016,
        desired_wa_hours: 8,
        actual_wa_hours: 7
      },
      {
        user_id: 1,
        week_number: 2,
        year: 2016,
        desired_wa_hours: 42,
        actual_wa_hours: 23
      }
    ]
    let result = getAllocationForWeekAndUser( timeAllocationInput, 3, 2016, 1)
    assert.equal(result[0], false);
    assert.equal(result[1], true);
    assert.equal(result[2].desired_wa_hours, 42);
    assert.equal(result[2].actual_wa_hours, null);
    assert.equal(result[2].year, 2016);
    assert.equal(result[2].week_number, 2);
    assert.equal(result[2].user_id, 1);
    assert.equal(result[2].id, null);
  });
});
