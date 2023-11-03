import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker(
      {Key? key,
      required this.oldTime,
      required this.text,
      required this.callBack})
      : super(key: key);
  final String oldTime;
  final String text;
  final Function(String) callBack;

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    initTime();
    super.initState();
  }

  void initTime() {
    selectedDate = DateTime.parse(widget.oldTime);
    selectedTime = TimeOfDay.fromDateTime(DateTime.parse(widget.oldTime));
  }

  void setTime() {
    widget.callBack(
        '${selectedDate.toString().split(' ')[0]} ${selectedTime.format(context)}');
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        setTime();
      });
    }
  }

  Future _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        setTime();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(2, (index) {
            return ElevatedButton(
              onPressed: () {
                index == 0 ? _selectDate(context) : _selectTime(context);
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(120, 50))),
              child: Text(index == 0 ? 'Select Date' : 'Select Time'),
            );
          }),
        ),
        const SizedBox(height: 20),
        Text(
          '${widget.text} : ${selectedDate.toString().split(' ')[0]} ${selectedTime.format(context)}',
          style: const TextStyle(
              fontSize: 14, color: Colors.black38, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
