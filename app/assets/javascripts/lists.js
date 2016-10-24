var CATEGORIES_SEARCH = [];
$(document).on('ready page:load', function () {
  $('a[href="' + this.location.pathname + '"]').parent().addClass('active');
  hideItemTableHead();
  hideCategorySelect();
  // createItemUnitTypeahead();

  setupSelectize('select#category_select', CATEGORIES_SEARCH, false);

  $('[data-toggle="popover"]').popover();
});

// function addNewOptionToSelect(selects, triggerSelect, option) {
//   for (var i = 0; i < selects.length; i++) {
//     var current = selects[i][0].selectize;
//     if (current != triggerSelect)
//       current.addOption(option);
//   };
// }

// $(document).on('click', '.remove_item', function() {
//   // NestedAttributesJs.remove(this);
//   // hideItemTableHead();
//   hideCategorySelect();
//   return false;
// });

function hideCategorySelect() {
  if($('#items-not-done tbody tr').length === 0 && $('#items-done tbody tr').length === 0){
    $('#category').hide();
  }
};

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
    message = confirm("Are you sure?");
    if(message) {
      $.post( "/lists/"+listId+"/items/"+itemId+"/undone", {category: categorySelected});
    } else {
     $(this).prop('checked', true);
    }
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
  $(this).find("#item-name").focus();
  setupSelectize('select#item_category_id', CATEGORIES, true);
  setupSelectize('select#item_unit_id', UNITS, true);
});

$(document).on('shown.bs.modal', "#newListModal", function() {
  $('#newListModalContent #list-name').focus();
});

$(document).on('shown.bs.modal', "#editListNameModal", function() {
  document.activeElement.blur();
  var input = $(this).find("#editListNameModalContent #list-name").focus();
  var tmpStr = input.val();
  input.val('');
  input.val(tmpStr);
});

$(document).on('shown.bs.modal', "#itemModal", function() {
  var input = $(this).find("#item-name").focus();
  var tmpStr = input.val();
  input.val('');
  input.val(tmpStr);
  setupSelectize('select#item_category_id', CATEGORIES, true);
  setupSelectize('select#item_unit_id', UNITS, true);
});

$(document).on('shown.bs.modal', "#editItemModal", function() {
  var input = $(this).find("#item-name").focus();
  var tmpStr = input.val();
  input.val('');
  input.val(tmpStr);
  setupSelectize('select#item_category_id', CATEGORIES, true);
  setupSelectize('select#item_unit_id', UNITS, true);
});

$(document).on('shown.bs.modal', "#newCategoryModal", function() {
  $(this).find('#category-name').focus();
});

$(document).on('shown.bs.modal', "#editCategoryNameModal", function() {
  var input = $(this).find('#category-name').focus();
  var tmpStr = input.val();
  input.val('');
  input.val(tmpStr);
});

function setupSelectize(selector, options, create) {
  $(selector).selectize({
    valueField: 'id',
    labelField: 'name',
    searchField: ['name'],
    options: options,
    create: create
  });
}
