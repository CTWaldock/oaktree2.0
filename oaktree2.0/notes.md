REQUIREMENTS

1. Must render one show page and one index page via jQuery and an Active Model Serialization JSON Backend. COMPLETED.

- Budget index page responds initially with HTML text, AJAX request is made for JSON files and the budget index page is then populated via jQuery.

- Category show page page renders by sending an AJAX get request to category/show, receives a JSON object created via Active Model Serializer, then initializes JavaScript objects out of that information and uses jQuery to fill in the DOM.

2. Must use your Rails api to create a resource and render the response without a page refresh. COMPLETED.

- Expense creation form uses AJAX to post to /categories/:id/expenses. ExpensesController returns the category in JSON form after creating the expense and jQuery updates the page with the new information.

3. The rails API must reveal at least one has-many relationship in the JSON that is then rendered to the page. COMPLETED.

- ExpensesController returns the category after an expense is created. Active Model Serializer includes a has_many :expenses relationship when returning the category object in JSON. This information is then used to both update the category show page and expenses tables with the new response and adjusted numbers.

4. Must have at least one link that loads, or updates a resource without reloading the page. COMPLETED.

- Deletes expenses on category show page via a link and updates the category information on the page without reloading.

- Clicking on a category on the budget show page loads the category show page without reloading the page through using AJAX requests, clearing the DOM, and repopulating it in with the information regarding the category.

5. Must translate the JSON responses into Javascript Model Objects. The Model Objects must have at least one method on the prototype. Formatters work really well for this. COMPLETED.

- Category show page returns JSON for budget, category, and expense, which are then turned into Javascript objects. Category and expense percentage methods are used to fill information.

- Budget index page returns JSON for budget, which uses the status prototype method in order to decide whether or not to apply a class to each link.

----------------

REFACTORING

Move all JavaScript files into respective model instead of having into view-specific scripts. COMPLETED.

Adjust initialization of objects to access JSON through dot notation rather than explicitly filling information in. COMPLETED.

Break apart functions that handle more than one responsibility. COMPLETED.

Add formatting methods to prototypes to convert into DOM insertion ready string. COMPLETED.

Abstract away into well named functions or add comments for any potentially confusing / unclear code. COMPLETED.

On the other hand, don't abstract away too much into ambiguous functions holding too much responsibility like 'handleExpenseSuccess' -- instead specifically call the methods that it calls when appropriate. COMPLETED.

Fix the expense form -- currently uncentered. COMPLETED.

Look into requesting HTML from the server for the budget show, new, and edit, page and then inserting that so we can continue to move seamlessly. COMPLETED.

------------------

Clear headers on inserting new content. COMPLETED.

Back button seems to render JSON instead of HTML. Fix that. COMPLETED.

Add error class to expense inputs on error. COMPLETED.

Push up jQuery to Heroku and figure out how to optimize speed. COMPLETED.

Add more model tests. COMPLETED.

Maybe support Firefox for the date input field through a placeholder or something. COMPLETED.

Add Webdriver to test and fix feature tests. COMPLETED.

----------------
Future Features

Separate category into a different model and have a join table between category and budgets?

Budget templates?

Household budget oriented direction: restrain budget flexibility, focus on monthly budgets, track percentage expenditure of categories throughout all budgets.

More flexibility and enterprise oriented direction: Add feature to allow users to invite others to budgets, budget admin dashboard, add/remove privileges to delete, update, edit, etc.
