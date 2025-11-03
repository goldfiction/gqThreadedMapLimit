Worker = require('worker_threads').Worker
async = require('async')

threadedMapLimit=(arr,limit,workerfile,cb1)->
    async.mapLimit arr,limit,(item,cb2) ->
        worker = new Worker(workerfile||'./worker.coffee')
        taskId = Math.random().toString(36).substring(7)
        # Unique ID for tracking
        worker.postMessage
            value: item
            taskId: taskId
        worker.on 'message',(message) ->
            if message.taskId == taskId
                cb2 null,message.result
                worker.terminate()
            return
        worker.on 'error',(e)->
            cb2(e)
            return
        worker.on 'exit',(code) ->
            #if code != 0
            #    console.log('Worker stopped with exit code '+code)
            return
    ,(err,results) ->
        if err
            console.error 'Error processing items:',err
            cb1 err
        else
            console.log 'Processed results:',results
            cb1 null,results
        return

@threadedMapLimit=threadedMapLimit

Array.prototype.threadedMapLimit=(limit,workerfile,cb1)->
    threadedMapLimit(this,limit,workerfile,cb1)