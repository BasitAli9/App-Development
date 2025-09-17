import 'dart:io';

void main() {
  // User input
  stdout.write("Enter a number: ");
  int n = int.parse(stdin.readLineSync()!);

  // Outer loop (rows)
  for (int i = 1; i <= n; i++) {
    // Inner loop (numbers in each row)
    for (int j = 1; j <= i; j++) {
      stdout.write("$j ");
    }
    print(""); // new line after each row
  }
}
