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
  $('[data-toggle="popover"]').popover();
  $('.category-select-search').each(function() {
    $(this).selectize({
      valueField: 'id',
      labelField: 'name',
      searchField: ['name'],
      options: CATEGORIES_SEARCH,
      create: false
    });
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

// $(document).on('click', '.remove_item', function() {
//   NestedAttributesJs.remove(this);
//   hideItemTableHead();
//   return false;
// });

function hideItemTableHead() {
  if ($('table#items tbody tr:not(.hidden)').length === 0) {
    $('table#items thead').addClass('hidden');
  } 
};

$(document).on('click','#items-not-done tr', function (ev) {
  if (ev.target.type !== 'checkbox' && $(ev.target).parent().attr('type') !== 'button') {
    $(this).find('input[type=checkbox]').trigger('click');
  } 
});

$(document).on('click','#items-done tbody tr', function (ev) {
  var $cell=$(ev.target).closest('td');
  if( $cell.index()>0){
    if ($(ev.target).closest('tr').find('a').attr('aria-describedby')) {
      $('#items-done').blur();
    } else{
      $(ev.target).closest('tr').find('a').trigger('focus');
    } 
  }
});

$(document).on('change', '.checkDone', function(e) {
  var categorySelected = $('#category_select').find(":selected").val();
  var itemId = $(this).attr('id');
  var listId = $(this).data('list');
  if ($(this).prop('checked') === true) {
    $.get( "/lists/"+listId+"/items/"+itemId+"/show_confirm_done", {category: categorySelected});
  } else {
    $.post( "/lists/"+listId+"/items/"+itemId+"/undone", {category: categorySelected});
  }
});

$(document).on('change', '#category_select', function (ev) {
  var selectedCategoryValue = $('#category_select').val();
  var listId = $(this).data('list');
  var changeCategoryUrl = "/lists/"+listId+"/change_category";
  $.ajax({
    method: "GET",
    url: changeCategoryUrl,
    dataType: 'text',
    data: { category: selectedCategoryValue }
  }).done(function( data ) {
    if (selectedCategoryValue === '0') {
      $("tr").removeClass('hidden');
    } else {
      $("tr[data-category!='"+selectedCategoryValue+"']").addClass('hidden');
      $("tr[data-category='"+selectedCategoryValue+"']").removeClass('hidden');
    }
    $('#total_sum').text(data);
  });
});

$(document).on('click', '#closeModal', function () {
  var itemId = $('#itemModalLabel').attr('data-item');
  $('.checkDone#'+itemId).removeProp('checked');
});

$(document).on('shown.bs.modal', "#addItemModal", function() {
  $('#item-name').focus();
});

$(document).on('shown.bs.modal', "#newListModal", function() {
  $('#list-name').focus();
});

$(document).on('shown.bs.modal', "#editListNameModal", function() {
  document.activeElement.blur();
  $(this).find("#list-name").focus();
});

$(document).on('shown.bs.modal', "#itemModal", function() {
  $(this).find("#item-qty").focus();
});
