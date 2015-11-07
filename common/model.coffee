@Rp_Comment_Model={}
Rp_Comment_Model.Reply=new SimpleSchema({
  message:
    type:String
    autoform:
      rows:5
  audience:
    type:[String]
    optional:true
    autoform:
      type:"hidden"
      label:false
  createdBy:
    type:String
    autoform:
      type:"hidden"
      label:false
    autoValue:->
      if @isUpdate then Meteor.userId()
    denyInsert:true
    optional:true
  createdAt:
    type:Date
    autoform:
      type:"hidden"
      label:false
    autoValue:->
      if @isUpdate then new Date()
    denyInsert:true
    optional:true
  updatedAt:
    type:Date
    autoform:
      type:"hidden"
      label:false
    autoValue:->
      if @isUpdate then new Date()
    denyInsert:true
    optional:true
})
Rp_Comment_Model.Comment=new SimpleSchema({
  message:
    type:String
    autoform:
      rows:5
  parent:
    type:String
    autoform:
      type:'hidden'
      label:false
  docId:
    type:String
    autoform:
      type:'hidden'
      label:false
  collection:
    type:String
    autoform:
      type:'hidden'
      label:false
  replies:
    type:[Rp_Comment_Model.Reply]
    optional:true
    defaultValue:[]
    autoform:
      type:"hidden"
      label:false
  isNew:
    type:Boolean
    defaultValue:true
    autoform:
      label:false
      type:'hidden'
  audience:
    type:[String]
    defaultValue:[]
    autoform:
      label:false
      type:"hidden"

})



@Rp_Comments=new Meteor.Collection('rp_comments',transform:(doc)->
  doc.owner=Meteor.users.findOne(doc.createdBy)
  _.each(doc.replies,(val,index)->
    val.index=index
    val.owner=Meteor.users.findOne(val.createdBy)
  )
  doc
)
Rp_Comments.attachSchema Rp_Comment_Model.Comment
Rp_Comments.attachBehaviour('timestampable')








