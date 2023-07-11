import 'dart:math';

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

  String generateRandomString() {
    Random random = Random();
    const int minLength = 8;
    const int maxLength = 8;
    const int upperCaseLettersStart = 65;
    const int upperCaseLettersEnd = 90;
    const int lowerCaseLettersStart = 97;
    const int lowerCaseLettersEnd = 122;

    String randomString = '';

    for (int i = 0; i < minLength; i++) {
      int randomNumber = random.nextInt(maxLength - minLength + 1) + minLength;

      if (randomNumber.isOdd) {
        // Generate an uppercase letter
        int randomUppercase =
            random.nextInt(upperCaseLettersEnd - upperCaseLettersStart + 1) +
                upperCaseLettersStart;
        randomString += String.fromCharCode(randomUppercase);
      } else {
        // Generate a lowercase letter
        int randomLowercase =
            random.nextInt(lowerCaseLettersEnd - lowerCaseLettersStart + 1) +
                lowerCaseLettersStart;
        randomString += String.fromCharCode(randomLowercase);
      }
    }

    return randomString;
  }
}
