const exec = require('cordova/exec');
const CDVUMeng = {
    getUMID:function (success){
        exec(success,null,'CDVUMeng','getUMID',[]);
    },
    setUId:function (option){
        exec(null,null,'CDVUMeng','setUId',[option]);
    },
};
module.exports = CDVUMeng;
