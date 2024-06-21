class ReplyService {
    static add(reply, callback, error) {
        $.ajax({
            type:"post",
            url:"/replies/new",
            data : JSON.stringify(reply),
            contentType : "application/json; charset=utf-8",
            success:function(result, status, xhr){
                if(callback){
                    callback(status)
                }
            },
            error:function(xhr, status, er){
               if(error) {
                error(xhr.status + '' + status);
               };
            }
        })
    }
    
    static getList(param, callback, error) {
        $.getJSON("/replies/pages/"+param.bno , function(data){
            callback(data);
        }).fail(function(xhr, status, er){
        })
        
    }
    
    static getListWithPaging(param, callback, error) {
    console.log("param" +param);
    	 $.getJSON("/replies/pages/"+param.bno+"/"+param.page , function(data){
            callback(data);
        }).fail(function(xhr, status, er){
        console.log("fail")
        })
    }
    
    static get(rno, callback, error) {
    	$.get("/replies/"+rno, function(data) {
    	callback(data);
    	}).fail(function(xhr, status, err){
        })
    }
    
    static modify(reply, callback, error) {
    console.log(reply);
    let rno=reply.rno;
    console.log(rno);
        $.ajax({
            type:"patch",
            url:"/replies/" +rno,
            data : JSON.stringify(reply),
            contentType : "application/json; charset=utf-8",
            success:function(result, status, xhr){
                if(callback){
                    callback(result)
                }
            },
            error:function(xhr, status, er){
               if(error) {
                error(xhr.status + '' + status);
               };
            }
        })
  	
    }
    
    static remove(rno, callback, error){
    console.log(rno);
    	 $.ajax({
            type:"delete",
            url:"/replies/" +rno,
            success:function(result, status, xhr){
                if(callback){
                    callback(status)
                }
            },
            error:function(xhr, status, er){
               if(error) {
                error(xhr.status + '' + status);
               };
            }
        })
    }
    
    static displayTime(t) {
	    var date = new Date(t*1);
	    var year = date.getFullYear();
	    var month = "0" + (date.getMonth()+1);
	    var day = "0" + date.getDate();
	    var hour = "0" + date.getHours();
	    var minute = "0" + date.getMinutes();
	    var second = "0" + date.getSeconds();
	    return year + "-" + month.substr(-2) + "-" + day.substr(-2) + " " + hour.substr(-2) + ":" + minute.substr(-2) + ":" + second.substr(-2);
    }
    
    
}