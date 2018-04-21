function Expense (params) {
  this.id = params.id;
  this.cost = params.cost;
  this.description = params.description;
}

Expense.prototype.percentage = function() {
  return Math.round(this.cost * 100 / this.category.subtotal);
}

Expense.prototype.expenseRow = function() {
  var description = '<th scope="row">' + this.description + '</th>';
  var percentage = '<td>' + this.percentage() + '%</td>';
  var cost = '<td>$' + this.cost.toFixed(2) + '</td>';
  var deleteLink = '<td><a href="/expenses/' + this.id + '">Delete Expense</a></td>';
  return ['<tr>', description, percentage, cost, deleteLink, '</tr>'].join("")
}

function resetErrors() {
  $('#error_message').text("");
  $('#error_list').empty();
  $('#expense_description').parent().removeClass('field_with_errors');
  $('#expense_cost').parent().removeClass('field_with_errors');
}

function resetExpenseTable() {
  $('tbody').empty();
}

function resetExpenseInput() {
  $('#new_expense')[0].reset();
}

function fillExpenseTable(category) {
  var expenses = category.expenses
  for (var i = 0; i < expenses.length; i++) {
    var expense = expenses[i];
    $('tbody').prepend(expense.expenseRow());
  }
}

function addErrors(errors) {
  $('#error_message').text("Please enter valid information.");
  for (var j = 0; j < errors.length; j++) {
    var error = errors[j];
    var errorID = "#expense_" + error.split(" ")[0].toLowerCase();
    $(errorID).parent().addClass('field_with_errors');
    $('#error_list').append('<li>' + error + '</li>');
  }
}

function bindExpenseForm() {
  $('#new_expense').on('submit', function(event) {
    event.preventDefault();
    var expenseParams = $(this).serialize();
    var expensePost = $.post(this.action, expenseParams);
    expensePost.done(function(data) {
      resetErrors();
      resetExpenseTable();
      resetExpenseInput();
      category = new Category(data);
      updateCategory(category);
      fillExpenseTable(category);
      bindExpenseDeleteLinks(); // need to rebind delete links as the table was deleted
    }).fail(function(error) {
      resetErrors();
      addErrors(JSON.parse(error.responseText).error);
    });
  });
}

function bindExpenseDeleteLinks() {
  $('td a').on('click', function(event) {
    event.preventDefault();
    link = this.href
    $.ajax({
      url: link,
      type: 'DELETE',
      success: function(data) {
        resetExpenseTable();
        category = new Category(data);
        updateCategory(category);
        fillExpenseTable(category); // need to rebind delete links as the table was deleted
        bindExpenseDeleteLinks();
      }
    });
  });
}
