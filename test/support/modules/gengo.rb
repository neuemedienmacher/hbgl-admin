WebMock.stub_request(
  :post, 'http://api.sandbox.gengo.com/v2/translate/jobs'
).to_return(status: 200, body: '{"opstat": "ok", "response":{"order_id":"1"}}')
