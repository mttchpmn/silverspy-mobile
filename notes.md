# Notes on upcoming features

## Payments page

- Page should show payment categories, position, totals, and overview, and a button to show all payments
- When going to the all payments screen there should be a button to add a new payment
- Tapping a payment in the list of payments should open that payment in a new screen, showing the details, a list of upcoming payments, and buttons to edit / remove etc
- Payments displayed in the all payments list should show a green arrow for incoming and a red arrow for outgoing
- Payments displayed in the list should display the category and frequency on each line item (Rather than details)

## Transactions page

- Page should show a period selector at the top to select period of transactions
- Page should show totals and position summary
- Page should show category totals underneath (that change when you change the period)
- When you tap a specific category, it should open those transactions in the transaction list screen
- Page should show a button to view all transactions
- Transaction list page should have a period selector at the top, and a list of all transactions underneath
- Tapping a transaction should open that transaction in a new screen, allowing you to view all fields, edit details, and update category etc

## Dashboard page

- Page should show:
  - Salutation
  - Period selector
  - Days remaining in period
  - Upcoming payments in remaining period
  - Transaction graph of lines plotting incoming and outgoing
  - Transaction category totals

## TODO

- Persist Akahu deets in the app and use for transaction ingest
- Fix 'details' entry in edit transaction dialog
- Create 'tags', that work like subcategories, using chips and can have more than 1 tag per transaction
- Flesh out dashboard page
- Budgets
  - Set a max category spend per week - track progress towards it using linear progress indicator and show in category totals
- Auto ingest transactions on app load
- Show 'normalized' weekly spend next to category totals?
- Add new categories?
  - INCOME
  - BILLS?
- Login Page improvements