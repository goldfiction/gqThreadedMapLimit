parentPort = require('worker_threads').parentPort

# override this file to implement actual jobs

job=(value,cb)->
  cb null,value*2

parentPort.on 'message',(taskData)->
    job taskData.value,(err,result)->
        if err
            parentPort.postMessage
                type: 'error'
                message: err
        else
            parentPort.postMessage
                result: result
                taskId: taskData.taskId
            return