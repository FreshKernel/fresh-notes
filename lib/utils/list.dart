// TODO: Refactor all of this

Iterable<T> findCommons<T>(Iterable<T> list1, Iterable<T> list2) {
  // Find the shared things only
  final commonItems = list1.toSet().intersection(list2.toSet());
  return commonItems;
}

/// Find the differences between two lists.
///
/// Given two lists, this function merges them into a combined list, removes
/// duplicates, , and returns
/// the elements that are unique to each list.
///
/// Example:
/// ```dart
/// List<int> list1 = [1, 2, 3, 4];
/// List<int> list2 = [3, 4, 5, 6];
///
/// List<int> differences = findDifferences(list1, list2);
/// print(differences); // Output: [1, 2, 5, 6]
/// ```
/// - Returns:
///   A list containing the elements that are unique to each list.
Iterable<T> findDifferences<T>(
  Iterable<T> list1,
  Iterable<T> list2, {
  required Iterable<T> commonItems,
}) {
  // Merge the two lists so we can get the unique items with no duplicates
  final combinedList = [...list1, ...list2];

  // Remove duplicates from the combined list
  final uniqueItems = combinedList.toSet().toList();

  // Find the differences by filtering
  final differences = uniqueItems // unique items is just the two list
      // with no duplication
      .where((item) => !commonItems.contains(item));
  return differences;
}

/// Find the missing elements between two lists.
///
/// Given two lists, this function identifies the elements that exist in the
/// first list but are missing from the second list.
///
/// Example:
/// ```dart
/// List<int> list1 = [1, 2, 3, 4];
/// List<int> list2 = [3, 4, 5, 6];
///
/// List<int> missingItems = findMissings(list1, list2);
/// print(missingItems); // Output: [1, 2]
/// ```
///
/// - Parameters:
///   - list1: The first list.
///   - list2: The second list.
///
/// - Returns:
///   A list containing the elements that are in `list1` but missing from `list2`.
Iterable<T> findMissings<T>(
  Iterable<T> list1,
  Iterable<T> list2,
) {
  if (list1.length == list2.length) {
    return List.empty();
  }

  // Determine the maximum length between the two lists
  final maxLength = list1.length > list2.length ? list1.length : list2.length;

  final missingItems = <T>[];

  // Loop through the indices from 0 to the maximum length
  for (var i = 0; i < maxLength; i++) {
    // Check if we have reached the end of either list
    if (!(i >= list1.length ||
        i >= list2.length ||
        list1.elementAt(i) != list2.elementAt(i))) {
      continue; // Skip to the next iteration if the elements are equal or if we've reached the end of both lists
    }
    if (i < list1.length) {
      // If we haven't reached the end of list1, add the element at index i from list1 to missingItems
      missingItems.add(list1.elementAt(i));
      continue; // Skip to the next iteration
    }
    if (i < list2.length) {
      // If we haven't reached the end of list2, add the element at index i from list2 to missingItems
      missingItems.add(list2.elementAt(i));
    }
  }
  return missingItems; // Return the list of missing items
}
