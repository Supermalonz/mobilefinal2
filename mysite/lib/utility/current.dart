class CurrentUser {
  static int id;
  static var userId;
  static var name;
  static var age;
  static var password;
  static var quote;

  static String current() {
    return "current -> _id: $id, userid: $userId, name: $name, age: $age, password: $password, quote: $quote";
  }
}