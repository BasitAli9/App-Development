import 'dart:io';

void main() {
  List<int> numbers = [];
  for (int i = 0; i < 6; i++) {
    stdout.write("Enter number ${i + 1}: ");
    int num = int.parse(stdin.readLineSync()!);
    numbers.add(num);
  }
  int oddSum = 0;
  for (int num in numbers) {
    if (num % 2 != 0) {
      oddSum += num;
    }
  }
  int smallest = numbers.reduce((a, b) => a < b ? a : b);
  print("\n===== Results =====");
  print("Numbers Entered: $numbers");
  print("Sum of Odd Numbers: $oddSum");
  print("Smallest Number: $smallest");
}
