class Constants {
  //api paths
  static const String HOST = "http://grocery-tracker.azurewebsites.net";
  static const String LOGIN_PATH = "/auth/login/";
  static const String PATCH_USER = "/users/";
  static const String GET_USER_PATH = "/users/";
  static const String REGISTER_PATH = "/users/";
  static const String SUBMIT_TRIP_PATH = "/users/trip";
  static const String LOAD_TRANSACTIONS_PATH = "/users/trip/";
  static const String GET_GOALS_PATH = "/users/goal/";
  static const String CREATE_GOALS_PATH = "/users/goal/";
  static const String RECOMMENDATIONS_PATH = "/recommendations";
  static const String RECOMMENDATIONS_LOWEST_PATH = "/recommendations/lowest";
  static const String DELETE_GOALS_PATH = "/users/goal/";
  static const String DELETE_TRANSACTION_PATH = "/users/trip/";

  //app name
  static const String APP_NAME = "Grocery Spending Tracker";

  //page titles
  static const String HOME = "Home";
  static const String NEW_TRIP = "New Trip";
  static const String CREATE_GOAL = "Create Goal";
  static const String PURCHASE_HISTORY = "Purchase History";
  static const String ANALYTICS = "Analytics";
  static const String PROFILE = "Profile";

  //user pages
  static const String NEW_ACCOUNT_TITLE = "New Account";
  static const String FIRST_NAME_LABEL = "First Name";
  static const String LAST_NAME_LABEL = "Last Name";
  static const String EMAIL_LABEL = "Email";
  static const String PASSWORD_LABEL = "Password";
  static const String OK_LABEL = "OK";
  static const String LOGIN_BUTTON_LABEL = "Login";
  static const String CREATE_ACCOUNT_BUTTON_LABEL = "Create Account";
  static const String GENERIC_INVALID_INPUT = "Invalid input";

  static const String DATE_TIME_LABEL = "Date and Time of Purchase";
  static const String LOCATION_LABEL = "Location (Address)";
  static const String ITEM_ID_LABEL = "Item ID (SKU)";
  static const String ITEM_NAME_LABEL = "Item Name";
  static const String TAXED_LABEL = "Taxed?";
  static const String ITEM_PRICE_LABEL = "Price";
  static const String CONFIRM_LABEL = "Confirm";
  static const String TRIP_SUBTOTAL_LABEL = "Subtotal";
  static const String TRIP_TOTAL_LABEL = "Total";
  static const String TRIP_DESC_LABEL = "Trip Description";
  static const String NEW_ITEM_LABEL = "NEW\nITEM";
  static const String LOGOUT_LABEL = "Logout";

  static const String SCAN_RECEIPT_LABEL = "Scan Receipt";
  static const String CONFIRM_RECEIPT_LABEL = "Confirm Scanned Receipt";
  static const String EDIT_ITEM_LABEL = "Edit Item";
  static const String ITEM_LIST_LABEL = "Item List";

  static const List<String> ADDRESSES = [
    '1579 Main Street West, Hamilton, ON L8S 1E6',
    '845 King Street West, Hamilton, ON L8S 1K4',
    '2 King Street West #445, Hamilton, ON L8P 1A2'
  ];
}
