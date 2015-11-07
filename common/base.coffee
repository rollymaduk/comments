class @Rp_Comment_Base
  commentChanged:(comment)->
  replyChanged:(reply,parent)->
  getComments:(qry={},modifier={})->
    Rp_Comments.find(qry,modifier).fetch()

  createNewReply:(doc,docId,replyIndex,callback)->
    if callback
      Meteor.call 'rp_add_reply',doc,docId,replyIndex,(err,res)->
        callback.call null,err,res
    else
      Meteor.call 'rp_add_reply',doc,docId,replyIndex

  createNewComment:(doc,audienceRef,docId,callback)->
    if callback
      Meteor.call 'rp_add_comment',doc,audienceRef,docId,(err,res)->
        callback.call null,err,res
    else
      Meteor.call 'rp_add_comment',doc,audienceRef,docId

  removeComments:(parentId,callback)->
    if callback
      Meteor.call 'rp_remove_comment',parentId,(err,res)->
        callback.call null,err,res
    else
      Meteor.call 'rp_remove_comment',parentId






