Template.registerHelper 'rp_comment_schema',()->
  Rp_Comment_Model.Comment

Template.registerHelper 'rp_comment_reply',()->
  Rp_Comment_Model.Reply

Template.registerHelper 'rp_comment_identity',(user)->
  ids=(for item in Rp_Comment.identityFields
    do (item)->
      res=item.split('.')
      res.unshift(user)
      res
  )
  (Meteor._get.apply null,identity for identity in ids).join(" ")

Template.registerHelper 'rp_comment_canEdit',(user)->
  Meteor.userId() is user

