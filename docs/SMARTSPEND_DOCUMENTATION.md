# SmartSpend: An Innovative Budget Tracker for Smarter Financial Habits

## Overview
SmartSpend is a Flutter-powered personal finance companion that helps users track daily expenses and income, plan budgets, and visualise their financial goals. The application is optimised for Material Design 3 and showcases a clean, modern interface inspired by the provided mock-ups.

## Architecture
The project follows a simple state-management approach using the [`provider`](https://pub.dev/packages/provider) package. It keeps presentation, business logic, and data models separated:

- `lib/models/` – Value objects for transactions, budget categories, and savings goals.
- `lib/providers/` – A `ChangeNotifier` (`FinanceProvider`) that stores all demo data, exposes computed values (income, expenses, balances), and offers mutating helpers such as `addTransaction`.
- `lib/screens/` – Top-level pages for each tab (Dashboard, Budget, Analytics, Accounts, Settings) and the bottom-sheet composer for new entries.
- `lib/widgets/` – Reusable UI components like summary cards and transaction tiles.
- `lib/theme.dart` – Custom colour palette and typography definitions.

The home shell (`HomeShell`) uses a `NavigationBar` with five destinations. An `AnimatedSwitcher` keeps the currently selected screen alive while providing smooth transitions.

## Key Features Implemented
- **Dashboard overview** – Highlights monthly totals, savings progress, and recent transactions. The Floating Action Button (FAB) opens a full-featured entry sheet.
- **Expense and income tracking** – Users capture transactions with categories, accounts, notes, and dates. The provider updates aggregate totals, budgets, and account balances instantly.
- **Custom budgets** – Budget cards show the current spend, remaining allowance, and visual progress per category.
- **Goal progress** – Savings goals contribute to the “Savings Progress” percentage on the dashboard.
- **Data visualisation** – The analytics screen uses `fl_chart` to render a pie chart and line chart summarising spending behaviour.
- **Account snapshot** – Displays balances per account alongside a net-worth summary and recent account actions.
- **Security & reminders settings** – Placeholder toggles and list items demonstrate how SmartSpend could expose authentication and notification preferences.

## Add Transaction Workflow
1. Tap the green **+** FAB on the Dashboard.
2. The draggable bottom sheet appears with toggles for **Expense**/**Income** and a dynamic currency header.
3. Provide the description, amount, category, account, optional notes, and adjust the date if needed.
4. Submit using the primary button. Validation ensures both description and amount are populated.
5. The `FinanceProvider.addTransaction` method updates transactions, per-category budgets, and account totals, then notifies all listening widgets.

## Extending the App
- **Persistent storage** – Connect the provider to a database (e.g., `sqflite`) or cloud backend for real data.
- **Authentication** – Replace placeholders with biometric or PIN login using packages like `local_auth`.
- **Notifications** – Integrate scheduled reminders for bills via `flutter_local_notifications`.
- **Reports export** – Generate CSV/PDF reports for historical spending.

## Running the Project
1. Install Flutter 3.13+.
2. From the repository root execute:
   ```bash
   flutter pub get
   flutter run
   ```
3. The seeded demo data populates immediately; add more transactions via the FAB to see the analytics update in real time.

## Design Notes
- Colours and layout spacing mimic the provided visual references while adhering to Material 3 components.
- Typography relies on the default Roboto family for clarity across platforms.
- Cards and progress indicators feature rounded corners and subtle shadows to create depth without overwhelming the user.

## Licensing
This project is distributed for demonstration purposes. Update `pubspec.yaml` and the repository license as required before production use.
