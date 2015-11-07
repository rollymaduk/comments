Template.rp_comments.created=->
  Rp_Comment.setUp(@data.docId,@data.collection,@data.parent)
  @autorun =>
    @subscribe "rp_comments",Rp_Comment.getFilter(),Rp_Comment.limit


Template.rp_comments.destroyed=->
  Rp_Comment.destroy()

Template.rp_comments.helpers
  comments:()->Rp_Comment.getComments()

Template.rp_comments.events
  'click .rp_add_comment':(evt,temp)->
    data=Rp_Comment.getNewComment()
    Rp_Comment.renderInput(Template.rp_comment_control,data,'#rp_comment_content')

Template.rp_comment_item.events
  'click .rp_reply_comment,.rp_comment_edit':(evt,temp)->
    data=if $(evt.target).hasClass('rp_reply_comment') then _.extend(scope:'replies',temp.data)
    else _.omit(temp.data,'replies')
    Rp_Comment.renderInput(Template.rp_comment_control,data,'#rp_comment_content')

Template.rp_reply_item.events
  'click .rp_comment_edit_2,.rp_reply_comment_2':(evt,temp)->
    data=_.extend(scope:'replies',temp.data,parent:Template.parentData()._id)
    data=if $(evt.target).hasClass('rp_reply_comment_2') then _.omit(data,'index')
    Rp_Comment.renderInput(Template.rp_comment_control,data,'#rp_comment_content')
###add a modal to body and load input form ###


Template.rp_comments.rendered=->
  that=@
  AutoForm.hooks
    rp_comment_form:
      onSuccess:()->
        $("#rp_comment_modal").modal('hide')

      onError:(formType,err)->console.log err

      onSubmit:(ins,mod,curr)->
        if curr.scope
          docId=@docId or curr.parent
          ins.audience=[curr.createdBy]
          console.log curr
          Rp_Comment.createNewReply(ins,docId,curr.index,(err,res)=>@done(err,res))
        else
          name=that.data.name
          item=if @docId then _.omit(mod,'$unset') else ins
          Rp_Comment.createNewComment(item,name,@docId,(err,res)=>@done(err,res))
        false
  ,true


Template.rp_comments.getData=->
  Template.currentData() or false

Template.rp_comments.setData=(key,data)->
  Template.currentData()[key]=data


