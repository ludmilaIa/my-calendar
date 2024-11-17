import 'package:flutter/material.dart';
import '../models/label.dart';
import '../widgets/add_label_dialog.dart';
import '../models/event.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  bool isAllDay = false;
  Label? selectedLabel;
  List<Label> labels = [];
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  bool isMultiDayMode = false;

  List<String> get _weekDays => ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  List<String> get _months => [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  List<DateTime> _getDaysInMonth(int month, int year) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    
    final daysInMonth = <DateTime>[];
    
    // Add empty slots for days before the first day of the month
    final firstWeekday = firstDayOfMonth.weekday;
    for (var i = 0; i < (firstWeekday + 6) % 7; i++) {
      daysInMonth.add(firstDayOfMonth.subtract(Duration(days: (firstWeekday + 6) % 7 - i)));
    }
    
    // Add all days of the month
    for (var i = 0; i < lastDayOfMonth.day; i++) {
      daysInMonth.add(DateTime(year, month, i + 1));
    }
    
    // Add empty slots for remaining days to complete the last week
    final remainingDays = (7 - daysInMonth.length % 7) % 7;
    for (var i = 1; i <= remainingDays; i++) {
      daysInMonth.add(lastDayOfMonth.add(Duration(days: i)));
    }
    
    return daysInMonth;
  }

  bool _isDateInRange(DateTime date) {
    if (selectedStartDate == null || selectedEndDate == null) return false;
    return (date.isAfter(selectedStartDate!.subtract(const Duration(days: 1))) &&
            date.isBefore(selectedEndDate!.add(const Duration(days: 1))));
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(currentMonth, currentYear);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade200,
        title: const Text('Add Event'),
        actions: [
          TextButton(
            onPressed: _saveEvent,
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Custom Calendar
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Month and Year Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              if (currentMonth == 1) {
                                currentMonth = 12;
                                currentYear--;
                              } else {
                                currentMonth--;
                              }
                            });
                          },
                        ),
                        Text(
                          '${_months[currentMonth - 1]} $currentYear',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              if (currentMonth == 12) {
                                currentMonth = 1;
                                currentYear++;
                              } else {
                                currentMonth++;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Weekday Headers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _weekDays
                          .map((day) => SizedBox(
                                width: 40,
                                child: Text(
                                  day,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    // Calendar Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1,
                      ),
                      itemCount: daysInMonth.length,
                      itemBuilder: (context, index) {
                        final date = daysInMonth[index];
                        final isSelected = selectedStartDate != null &&
                            date.year == selectedStartDate!.year &&
                            date.month == selectedStartDate!.month &&
                            date.day == selectedStartDate!.day;
                        final isCurrentMonth = date.month == currentMonth;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isMultiDayMode) {
                                if (selectedStartDate == null) {
                                  selectedStartDate = date;
                                  selectedEndDate = date;
                                } else {
                                  if (date.isBefore(selectedStartDate!)) {
                                    selectedEndDate = selectedStartDate;
                                    selectedStartDate = date;
                                  } else {
                                    selectedEndDate = date;
                                  }
                                }
                              } else {
                                selectedStartDate = date;
                                selectedEndDate = date;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected || _isDateInRange(date)
                                  ? Colors.orange
                                  : null,
                              border: Border.all(
                                color: isSelected || _isDateInRange(date) 
                                    ? Colors.orange 
                                    : Colors.transparent,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: isSelected || _isDateInRange(date)
                                      ? Colors.white
                                      : isCurrentMonth
                                          ? Colors.black
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isMultiDayMode = !isMultiDayMode;
                  if (!isMultiDayMode) {
                    // Clear all selections when disabling multi-day mode
                    selectedStartDate = null;
                    selectedEndDate = null;
                  }
                });
              },
              icon: const Icon(Icons.date_range),
              label: const Text('Multiple Days'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isMultiDayMode ? Colors.orange : Colors.orange.shade100,
                foregroundColor: isMultiDayMode ? Colors.white : Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            if (isMultiDayMode && selectedStartDate != null && selectedEndDate != null && selectedStartDate != selectedEndDate)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Selected Range: ${selectedStartDate!.day}/${selectedStartDate!.month} - ${selectedEndDate!.day}/${selectedEndDate!.month}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            // Rest of the form remains the same
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SwitchListTile(
                title: const Text('All Day Event'),
                value: isAllDay,
                onChanged: (value) {
                  setState(() => isAllDay = value);
                },
              ),
            ),
            if (!isAllDay) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ListTile(
                        title: const Text('Start Time'),
                        subtitle: Text(startTime.format(context)),
                        onTap: () => _selectTime(context, true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ListTile(
                        title: const Text('End Time'),
                        subtitle: Text(endTime.format(context)),
                        onTap: () => _selectTime(context, false),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            const Text('Labels', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: [
                ...labels.map((label) => ChoiceChip(
                      label: Text(label.name),
                      selected: selectedLabel == label,
                      backgroundColor: label.color.withOpacity(0.2),
                      onSelected: (selected) {
                        setState(() => selectedLabel = selected ? label : null);
                      },
                    )),
                ActionChip(
                  label: const Text('+ Add Label'),
                  onPressed: _showAddLabelDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Comments',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  void _showAddLabelDialog() {
    showDialog(
      context: context,
      builder: (context) => AddLabelDialog(
        onAdd: (label) {
          setState(() => labels.add(label));
        },
      ),
    );
  }

  void _saveEvent() {
    if (_titleController.text.isNotEmpty && selectedStartDate != null) {
      final event = Event(
        title: _titleController.text,
        date: selectedStartDate!,
        label: selectedLabel,
        comments: _commentController.text.isNotEmpty ? _commentController.text : null,
        isAllDay: isAllDay,
        startTime: isAllDay ? null : startTime,
        endTime: isAllDay ? null : endTime,
      );
      Navigator.pop(context, event);
    }
  }
}