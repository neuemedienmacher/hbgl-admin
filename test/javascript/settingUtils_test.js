var assert = require('assert');
import { analyzeFields, denormalizeIndexResults }
  from '../../client/app/lib/settingUtils'

describe('analyzeFields', function() {
  it('should return one collection for string input', function() {
    let analyzed_fields = analyzeFields(['testData'], 'testModel');
    assert.equal(analyzed_fields[0].name, 'testData');
    assert.equal(analyzed_fields[0].relation, 'own');
    assert.equal(analyzed_fields[0].model, 'testModel');
    assert.equal(analyzed_fields[0].field, 'testData');
  });

  it('should return multiple collections for multiple inputs', function() {
    let analyzed_fields = analyzeFields(['data1', 'data2', 'data3'], 'model');
    assert.equal(analyzed_fields[0].name, 'data1');
    assert.equal(analyzed_fields[0].relation, 'own');
    assert.equal(analyzed_fields[0].model, 'model');
    assert.equal(analyzed_fields[0].field, 'data1');

    assert.equal(analyzed_fields[1].name, 'data2');
    assert.equal(analyzed_fields[1].relation, 'own');
    assert.equal(analyzed_fields[1].model, 'model');
    assert.equal(analyzed_fields[1].field, 'data2');

    assert.equal(analyzed_fields[2].name, 'data3');
    assert.equal(analyzed_fields[2].relation, 'own');
    assert.equal(analyzed_fields[2].model, 'model');
    assert.equal(analyzed_fields[2].field, 'data3');
  });

  it('returns two collections for an associated model & two fields', function() {
    let analyzed_fields = analyzeFields([{model: ['field1', 'field2']}], 'model');
    assert.equal(analyzed_fields[0].name, 'model field1');
    assert.equal(analyzed_fields[0].relation, 'association');
    assert.equal(analyzed_fields[0].model, 'model');
    assert.equal(analyzed_fields[0].field, 'field1');

    assert.equal(analyzed_fields[1].name, 'model field2');
    assert.equal(analyzed_fields[1].relation, 'association');
    assert.equal(analyzed_fields[1].model, 'model');
    assert.equal(analyzed_fields[1].field, 'field2');
  });
});

describe('denormalizeIndexResults', function() {
  it('should replace relation with more complex data if needed', function() {
    let results = {
      data: [
        {
          id: 42,
          attributes: {field: 'content1', relation1: 'content2'},
          relationships: {relation1: {
            data: {
              id: 23,
              type: 'someType'
            }
          } }
        }
      ],
      included: [
        {id: 1, type: 'shouldNotSeeMe'}, {id: 23, type: 'someType', attributes: {field: 'otherAttribute'} }
      ]
    }
    let denormalized_result = denormalizeIndexResults(results);

    assert.equal(denormalized_result[0].field, 'content1');
    assert.equal(denormalized_result[0].relation1.field, 'otherAttribute');
    assert.equal(denormalized_result[0].id, 42);
  });
});
