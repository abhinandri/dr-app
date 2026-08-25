String formatToAmPm(String time) {
  try {
    // If already contains AM/PM, return as is
    if (time.toUpperCase().contains('AM') ||
        time.toUpperCase().contains('PM')) {
      return time;
    }

    // Handle 24-hour format like "14:30"
    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "$hour:$minute $period";
  } catch (e) {
    return time; // fallback safe
  }
}