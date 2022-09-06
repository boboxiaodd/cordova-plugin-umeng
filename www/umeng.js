const exec = require('cordova/exec');
const CDVUMeng = {
    getUMID:function (success){
        exec(success,null,'CDVUMeng','getUMID',[]);
    }
};
module.exports = CDVUMeng;
