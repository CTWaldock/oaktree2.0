function Budget (params) {
  this.name = params.name;
  this.id = params.id;
  this.limit = params.limit;
  this.totalExpense = params.total_expense;
}

Budget.prototype.exceeded = function() {
  return (this.totalExpense > this.limit);
}

Budget.prototype.showLink = function() {
  return '<a href="/budgets/' + this.id + '"><p>' + this.name + '</p></a>';
}

function populateIndex() {
  $.get('/user/budgets', function(data) {
    $("#active").append('<h3>Active Budgets</h3>');
    insertBudgets(data.active, "#active");
    $("#inactive").append('<h3>Inactive Budgets</h3>');
    insertBudgets(data.inactive, "#inactive");
    $("#completed").append('<h3>Completed Budgets</h3>');
    insertBudgets(data.completed, "#completed");
    bindBudgetShowLinks();
  }, "JSON")
}

function insertBudgets(budgetList, selector) {
  $.each(budgetList, function(index, params) {
    var budget = new Budget(params);
    $(selector).append(budget.showLink());
    // turn link red if budget is exceeded
    if (budget.exceeded()) {
      $(selector).children().last().addClass("warning");
    }
  });
}

function bindBudgetShowLinks() {
  $('.budget_link a').on('click', function(event) {
    event.preventDefault();
    $.get(this.href).success(function(data) {
      replaceContent(data);
      bindCategoryShowLinks();
      bindBudgetEditLink();
    });
  });
}

function bindBudgetNewLink() {
  $('.new_budget a').on('click', function(event) {
    event.preventDefault();
    $.get(this.href).success(function(data) {
      replaceContent(data);
      bindNewBudgetForm();
    });
  });
}

function bindBudgetEditLink() {
  $('.edit_budget a').on('click', function(event) {
    event.preventDefault();
    $.get(this.href).success(function(data) {
      replaceContent(data);
      bindEditBudgetForm();
    })
  })
}

function bindEditBudgetForm() {
  $('.edit_budget').on('submit', function(event) {
    event.preventDefault();
    budgetParams = $(this).serialize();
    $.ajax({
      url: this.action,
      type: 'PUT',
      data: budgetParams,
      success: function(data) {
        replaceContent(data);
        bindCategoryShowLinks();
        bindBudgetEditLink();
      },
      error: function(error) {
        replaceContent(error.responseText);
        bindEditBudgetForm();
      }
    })
  })
}

function bindNewBudgetForm() {
  $('#new_budget').on('submit', function(event) {
    event.preventDefault();
    budgetParams = $(this).serialize();
    budgetPost = $.post(this.action, budgetParams);
    budgetPost.success(function(data) {
      replaceContent(data);
      bindCategoryShowLinks();
      bindBudgetEditLink();
    });
    budgetPost.fail(function(error) {
      replaceContent(error.responseText);
      bindNewBudgetForm();
    });
  });
}
