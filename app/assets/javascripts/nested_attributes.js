var NestedAttributesJs = {
  remove: function(e){
    var hidden_field = $(e).prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
      $(e).parents('.fields').addClass('hidden');
    } else {
      $(e).parents('.fields').remove();
    }
  },
  add : function(e) {
    var assoc   = $(e).data('association');
    var template = eval(assoc + '_template');
    template =  NestedAttributesJs.replace_ids(template);
    var elmToAppend = "#"+assoc;
    $(elmToAppend).append(template);
  },
  replace_ids : function(template){
    var new_id = new Date().getTime();
    return template.replace(/NEW_RECORD/g, new_id);
  }
};

