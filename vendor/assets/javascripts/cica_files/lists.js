$(document).on('ready page:load', function () {
  $('a[href="' + this.location.pathname + '"]').parent().addClass('active');
  hideItemTableHead();
  // createItemUnitTypeahead();
  var selects = [];
  $('.category-select').each(function() {
    var select = $(this).selectize({
      valueField: 'id',
      labelField: 'name',
      searchField: ['name'],
      options: CATEGORIES,
      create: true,
      onOptionAdd: function (value, data) {
        // console.log(value);
        // console.log(data);
        addNewOptionToSelect(selects, this, data);
      }
    });
    selects.push(select);
  });
  
});

function addNewOptionToSelect(selects, triggerSelect, option) {
  for (var i = 0; i < selects.length; i++) {
    var current = selects[i][0].selectize;
    if (current != triggerSelect)
      current.addOption(option);
  };
}

$(document).on('click', '.add_item', function() {
  $('table#items thead').removeClass('hidden');
  NestedAttributesJs.add(this);
  $('tr.fields').last().find('.category-select').selectize({
    valueField: 'id',
    labelField: 'name',
    searchField: ['name'],
    options: CATEGORIES,
    create: true
  });
  // createItemUnitTypeahead();
  return false;
});

$(document).on('click', '.remove_item', function() {
  NestedAttributesJs.remove(this);
  hideItemTableHead();
  return false;
});

function hideItemTableHead() {
  if ($('table#items tbody tr:not(.hidden)').length === 0) {
    $('table#items thead').addClass('hidden');
  } 
};

// $(document).on('click', '.checkDone:checkbox', function(e) {
  $(document).ready(function() {
  // if($(e.currentTarget).val(true)){
  // }
    $('.checkDone').change(function() {
      // if($(this).is(":checked")) {
        var categorySelected = $('#category_select').find(":selected").val();
        var listId = $(this).parent().parent().attr('id');
        $.post( "/lists/"+listId+"/item_done/:item_id", {catSel: categorySelected}, function() {});
      // }    
    });
});

$(document).on('change', '#category_select', function (ev) {
  var selectedCategoryValue = $('#category_select').val();
  $("tr[data-category!='"+selectedCategoryValue+"']").addClass('hidden');
  $("tr[data-category='"+selectedCategoryValue+"']").removeClass('hidden');
});

