class Tools {
  String splitName(String name) {
    List<String> nameParts = name.split(' ');

    if (nameParts.length > 2) {
      String firstName = nameParts[0];
      // Do something with the first name and last name
      return firstName;
    } else {
      // The name is not in the "first name last name" format
      // Handle the single-word name as needed
      return name;
    }
  }
}
