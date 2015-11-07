class Rp_Comment_Server extends Rp_Comment_Base
  constructor:(@limit=20)->
    that=@
    Meteor.startup ()->
      Meteor.publish 'rp_comments',(qry,limit)->
        limit=limit or @limit
        if @userId
          qry=_.extend(qry,$or:[{createdBy:@userId},audience:$in:[@userId]])
          console.log qry
          Rp_Comments.find(qry,{limit:limit,sort:createdAt:-1})
        else
          @ready()
    @models=[]

    Meteor.methods
      rp_remove_comment:(parentId)->
        try
          check(@userId,String)
          check(parentId,String)
          Rp_Comments.remove(parent:parentId)
        catch err
          throw new Meteor.Error err.id,err.message


      rp_add_comment:(message,name,docId)->
        try
          check(@userId,String)
          unless docId
            message.audience=Rp_Comment.getAudience(message.collection,message.docId,name)
            res=Rp_Comments.insert(message)
          else
            Rp_Comments.update(docId,message)
          docId=docId or res
          doc=Rp_Comments.findOne(docId)
          that.commentChanged.call null,doc
        catch err
          throw new Meteor.Error 4001,err.message


      rp_add_reply:(message,docId,index)->
        try
          check(@userId,String)
          check(message,Object)
          check(docId,String)
          unless _.isNumber(index)
            Rp_Comments.update(docId,{$addToSet:replies:message})
          else
            modifier={}
            modifier["replies.#{index}"]=message
            Rp_Comments.update(docId,{$set:modifier})

          doc=Rp_Comments.findOne(docId)
          doc.replies.sort((a,b)->new Date(b.updatedAt) - new Date(a.updatedAt))
          that.replyChanged.call null,doc.replies[0],doc._id
        catch err
          throw new Meteor.Error 4002,err.message



  setModel:(models)->
    check(models,[{name:Match.Optional(String),audience:Match.Optional(Match.Where (x)->_.isFunction(x))}])
    @models=models

  getAudience:(collection,docId,name)->
    model=_.findWhere(@models,{name:name})
    doc=eval(collection).findOne({_id:docId})
    if model then model.audience.call null,doc else []




Rp_Comment=new Rp_Comment_Server()




