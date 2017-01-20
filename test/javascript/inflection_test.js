var assert = require('assert');
import { pluralize } from '../../client/app/lib/inflection'

describe('pluralize', function() {
  it('should return the correct pluralization for various words', function() {
    assert.equal(pluralize('quiz'), 'quizzes');
    assert.equal(pluralize('oxen'), 'oxen');
    assert.equal(pluralize('ox'), 'oxen');
    assert.equal(pluralize('mice'), 'mice');
    assert.equal(pluralize('lice'), 'lice');
    assert.equal(pluralize('mouse'), 'mice');
    assert.equal(pluralize('louse'), 'lice');
    assert.equal(pluralize('matrix'), 'matrices');
    assert.equal(pluralize('vertex'), 'vertices');
    assert.equal(pluralize('index'), 'indices');
    assert.equal(pluralize('fox'), 'foxes');
    assert.equal(pluralize('hive'), 'hives');
    assert.equal(pluralize('elf'), 'elves');
    assert.equal(pluralize('basis'), 'bases');
    assert.equal(pluralize('bus'), 'buses');
    assert.equal(pluralize('tomato'), 'tomatoes');
    assert.equal(pluralize('buffalo'), 'buffaloes');
    assert.equal(pluralize('alias'), 'aliases');
    assert.equal(pluralize('status'), 'statuses');
    assert.equal(pluralize('octopi'), 'octopi');
    assert.equal(pluralize('octopus'), 'octopi');
    assert.equal(pluralize('virus'), 'viri');
    assert.equal(pluralize('test'), 'tests');
  });
});
