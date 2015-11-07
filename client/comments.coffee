class Rp_Comment_Client extends Rp_Comment_Base
  constructor:(@limit=20)->
    @config={ style:"bootstrap"}
    Meteor.startup =>
      template=Template[_templates[@config.style]]
      _view=Blaze.toHTML(template)
      $(_view).appendTo("body")
      $("##{_templates[@config.style]}").on('hidden.bs.modal', ()->
        Blaze.remove(_controlView)
      )




  ###private variables###
  _filter=new ReactiveVar()
  _parent=undefined
  _docId=undefined
  _collection=undefined
  _view=undefined
  _controlView=undefined
  _templates={'bootstrap':'rp_comment_modal'}



  getNewComment:()->
    {docId:_docId,collection:_collection,parent:_parent}

  setIdentity:(fields)->
    check(fields,[String])
    @identityFields=fields

  renderInput:(template,data,selector)->
    $(selector).empty()
    _controlView=Blaze.renderWithData(template,data,$(selector)[0])


  setUp:(docId,collection,parent,modalTemplate)->
    check(docId,String)
    check(collection,String)
    _parent=parent or docId
    _docId=docId
    _collection=collection
    @setIdentity(['emails.0.address'])
    @setFilter({docId:_docId})



  destroy:()->
    _parent=undefined
    _docId=undefined
    _collection=undefined
    @setIdentity([])
    @setFilter({})

  setFilter:(filter)->_filter.set(filter)

  getFilter:()->_filter.get()

  modalHandle:undefined


Rp_Comment=new Rp_Comment_Client()