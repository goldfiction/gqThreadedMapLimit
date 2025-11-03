app=require '../app.coffee'
assert=require 'assert'
tests=require 'gqtest'
it=tests.it
xit=tests.xit

testResult=[
   0,  2,  4,  6,  8,
  10, 12, 14, 16, 18
]
testResult=JSON.stringify(testResult)

# dummy test for code integrity
it "should be able to run",(done)->
  done()

xit "should be able to get abc",(done)->
  assert.equal app.abc,"abc"
  done()

it "should be able to run threaded worker",(done)->
  arr=[0..9]
  worker="./worker.coffee"
  final=(e,r)->
    # console.log r
    assert.equal JSON.stringify(r),testResult
    done(e)
  app.threadedMapLimit arr,3,worker,final
  null

it "should be able to run threaded worker on array",(done)->
  arr=[0..9]
  # override this file to allow actual worker
  worker="./worker.coffee"

  final=(e,r)->
    # console.log r
    assert.equal JSON.stringify(r),testResult
    done(e)

  # this method is in Array.prototype.threadedMapLimit
  arr.threadedMapLimit 3,worker,final
  null

tests.doRun()