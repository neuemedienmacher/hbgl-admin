var assert = require('assert');
import { isCurrentUserAssignedToModel, isTeamOfCurrentUserAssignedToModel }
  from '../../client/app/lib/restrictionUtils'

describe('isCurrentUserAssignedToModel', function() {
  it('must be undefined for missing data', function() {
    assert.equal(isCurrentUserAssignedToModel([], 'someModel', 1), undefined)
  });

  it('must be undefined for existing model without current assignment', function() {
    let entities = {someModel: {1: 'itMattersNot'}}
    let model = 'someModel'
    let id = 1
    assert.equal(isCurrentUserAssignedToModel(entities, model, id), undefined)
  });

  it('must be false when the user is not assigned', function() {
    // current_user (id: 22) is not assigned to someModel (reciever_id: 23)
    let entities = {
      current_user: {id: 22},
      someModel: {1: {
        current_assignment: {id: 42}
      }},
      assignments: {42: {
        reciever_id: 23
      }}
    }
    assert.equal(isCurrentUserAssignedToModel(entities, 'someModel', 1), false)
  });

  it('must be true when the user is assigned', function() {
    let entities = {
      current_user: {id: 23},
      someModel: {1: {
        current_assignment: {id: 42}
      }},
      assignments: {42: {
        reciever_id: 23
      }}
    }
    assert.equal(isCurrentUserAssignedToModel(entities, 'someModel', 1), true)
  });
});

describe('isTeamOfCurrentUserAssignedToModel', function() {
  it('must be undefined for missing data', function() {
    assert.equal(isTeamOfCurrentUserAssignedToModel([], 'someModel', 1), undefined)
  });

  it('must be undefined for existing model without current assignment', function() {
    let entities = {someModel: {1: 'itMattersNot'}}
    let model = 'someModel'
    let id = 1
    assert.equal(isTeamOfCurrentUserAssignedToModel(entities, model, id), undefined)
  });

  it('must be false when the users current_team is not assigned', function() {
    // current_team_id (id: 1) is not assigned to someModel (reciever_team_id: 2)
    let entities = {
      users: { 22:{ current_team_id: 1 }},
      current_user: {id: 22, current_team_id: 1},
      someModel: {1: {
        current_assignment: {id: 42}
      }},
      assignments: {42: {
        reciever_team_id: 2
      }}
    }
    assert.equal(isTeamOfCurrentUserAssignedToModel(entities, 'someModel', 1), false)
  });

  it('must be true when the users current_team is assigned', function() {
    let entities = {
      users: { 22:{ current_team_id: 2 }},
      current_user: {id: 22, current_team_id: 2},
      someModel: {1: {
        current_assignment: {id: 42}
      }},
      assignments: {42: {
        reciever_team_id: 2
      }}
    }
    assert.equal(isTeamOfCurrentUserAssignedToModel(entities, 'someModel', 1), true)
  });
});
