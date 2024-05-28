import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class DateController extends GetxController {
  final _selectedDate = ''.obs;

  String get selectedDate => _selectedDate.value;

  set selectedDate(String date) => _selectedDate.value = date;

  late StreamSubscription<DateTime> _dateStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    // Start the date stream
    _startDateStream();
  }

  @override
  void onClose() {
    super.onClose();
    // Cancel the stream subscription when the controller is closed
    _dateStreamSubscription.cancel();
  }

  void _startDateStream() {
    // Create a stream that emits DateTime events every second
    final Stream<DateTime> dateTimeStream = Stream<DateTime>.periodic(
      Duration(seconds: 1),
      (count) => DateTime.now(),
    );

    // Subscribe to the stream and update the selected date
    _dateStreamSubscription = dateTimeStream.listen((dateTime) {
      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(dateTime);
      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
      selectedDate = formattedDate;
    });
  }
}
