Template.rp_comments.created=->
  Rp_Comment.setUp(@data.docId,@data.collection,@data.parent)
  @data.options=_.defaults({canAddComment:true,canEditComment:true,canReplyComment:true},@data.options)
  @autorun =>
    @subscribe "rp_comments",Rp_Comment.getFilter(),Rp_Comment.limit


Template.rp_comments.destroyed=->
  Rp_Comment.destroy()

Template.rp_comments.helpers
  comments:()->Rp_Comment.getComments().map (doc)->_.extend(doc,Template.instance().data.options)

Template.rp_comments.events
  'click .rp_add_comment':(evt,temp)->
    data=Rp_Comment.getNewComment()
    data.schema="Rp_Comment_Model.Comment"
    Rp_Comment.renderInput(Template.rp_comment_control,data,'#rp_comment_content')

Template.rp_comment_item.created=->
  console.log @data

Template.rp_comment_item.events
  'click .rp_add_reply,.rp_edit_comment':(evt,temp)->
    if $(evt.target).hasClass('rp_add_reply')
      data={}
      data.refId=temp.data._id
      data.schema="Rp_Comment_Model.Reply"
      data.audience=[temp.data.createdBy]
    else
      data=_.omit(temp.data,'replies')
      data.schema="Rp_Comment_Model.Comment"

    Rp_Comment.renderInput(Template.rp_comment_control,data,'#rp_comment_content')
    ###data=if $(evt.target).hasClass('rp_reply_comment') then _.extend(scope:'replies',temp.data)
    else _.omit(temp.data,'replies')
    ###

Template.rp_reply_item.events
  'click .rp_reply_reply,.rp_edit_reply':(evt,temp)->
    if $(evt.target).hasClass('rp_reply_reply')
      data={}
      data.refId=temp.data.refId
      data.audience=[temp.data.createdBy]
    else
      data=temp.data

    data.schema="Rp_Comment_Model.Reply"
    Rp_Comment.renderInput(Template.rp_comment_control,data,'#rp_comment_content')



Template.rp_comments.rendered=->
  that=@
  AutoForm.hooks
    rp_comment_form:
      onSuccess:()->
        $("#rp_comment_modal").modal('hide')

      onError:(formType,err)->console.log err

      onSubmit:(ins,mod,curr)->
        console.log curr
        if curr.schema is "Rp_Comment_Model.Reply"
          ###ins.audience=[curr.createdBy]###
          console.log ins
          Rp_Comment.createNewReply(ins,curr.index,(err,res)=>@done(err,res))
        else
          name=that.data.name
          debugger
          item=if @docId then _.omit(mod,'$unset') else ins
          Rp_Comment.createNewComment(item,name,@docId,(err,res)=>@done(err,res))
        false
  ,true


Template.rp_comments.getData=->
  Template.currentData() or false

Template.rp_comments.setData=(key,data)->
  Template.currentData()[key]=data


