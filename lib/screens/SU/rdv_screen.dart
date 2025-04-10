import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'details_modal.dart';
import '../../widgets/colors.dart';

class RDVScreen extends StatefulWidget {
  @override
  _RDVScreenState createState() => _RDVScreenState();
}

class _RDVScreenState extends State<RDVScreen> {
  DateTime selectedDate = DateTime.now();
  bool isCalendarVisible = true;

  @override
  Widget build(BuildContext context) {
    bool isPhone = MediaQuery.of(context).size.width < 600;

    if (isPhone) {
      // Phone layout: Wrap in SafeArea so the UI does not overlap with system elements.
      return Scaffold(
        backgroundColor: AppColors.primaryLight,
        body: SafeArea(
          child: Stack(
            children: [
              // Full screen planning day box
              Positioned.fill(
                child: _PlanningDayBox(
                  selectedDate: selectedDate,
                  key: ValueKey<DateTime>(selectedDate),
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),
              // Overlay the mini calendar when visible
              if (isCalendarVisible)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withOpacity(0.95),
                    padding: EdgeInsets.all(10),
                    child: MiniCalendarBox(
                      onDateSelected: (newDate) {
                        setState(() {
                          selectedDate = newDate;
                          // Optionally hide the mini calendar after date selection
                          isCalendarVisible = false;
                        });
                      },
                    ),
                  ),
                ),
              // Toggle button (positioned at top right)
              Positioned(
                top: 3,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCalendarVisible = !isCalendarVisible;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        isCalendarVisible ? Icons.chevron_left : Icons.chevron_right,
                        key: ValueKey<bool>(isCalendarVisible),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // PC layout: wrap the main content in SafeArea
      return Scaffold(
        backgroundColor: AppColors.primaryLight,
        body: SafeArea(
          child: Stack(
            children: [
              Row(
                children: [
                  // Mini Calendar with smooth animation
                  AnimatedSize(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: isCalendarVisible ? 300 : 0,
                      color: AppColors.primaryLight,
                      padding: EdgeInsets.all(10),
                      child: isCalendarVisible
                          ? MiniCalendarBox(
                              onDateSelected: (newDate) {
                                setState(() {
                                  selectedDate = newDate;
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  // Main content area - Planning Day Box
                  Expanded(
                    child: AnimatedPadding(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.only(left: 0),
                      child: Column(
                        children: [
                          _PlanningDayBox(
                            selectedDate: selectedDate,
                            key: ValueKey<DateTime>(selectedDate),
                            onDateChanged: (newDate) {
                              setState(() {
                                selectedDate = newDate;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Toggle button for mini calendar (PC version)
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                top: 10,
                left: isCalendarVisible ? 259 : 45,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCalendarVisible = !isCalendarVisible;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        isCalendarVisible ? Icons.chevron_left : Icons.chevron_right,
                        key: ValueKey<bool>(isCalendarVisible),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class MiniCalendarBox extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const MiniCalendarBox({
    Key? key,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _MiniCalendarBoxState createState() => _MiniCalendarBoxState();
}

class _MiniCalendarBoxState extends State<MiniCalendarBox>
    with SingleTickerProviderStateMixin {
  late DateTime currentMonth;
  late DateTime selectedDate;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    currentMonth = today;
    selectedDate = today;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPhone = MediaQuery.of(context).size.width < 600;
    double calendarWidth = isPhone ? MediaQuery.of(context).size.width * 0.9 : 300;

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: isPhone ? 20.0 : 0.0),
        child: Stack(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: calendarWidth,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                ),
                child: Column(
                  children: [
                    _buildMonthChanger(),
                    _buildMiniCalendar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthChanger() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
            onPressed: () {
              setState(() {
                currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
              });
            },
          ),
          Expanded(
            child: Text(
              DateFormat.yMMMM('fr_FR').format(currentMonth),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: AppColors.primaryColor),
            onPressed: () {
              setState(() {
                currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCalendar() {
    List<String> weekDays = ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"];
    int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    int firstWeekday = DateTime(currentMonth.year, currentMonth.month, 1).weekday % 7;
    DateTime today = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: weekDays.map((day) {
              return Expanded(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                ),
              );
            }).toList(),
          ),
          Divider(
            color: AppColors.primaryColor,
            thickness: 1,
            height: 15,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: daysInMonth + firstWeekday,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              if (index < firstWeekday) {
                return Container();
              }
              int day = index - firstWeekday + 1;
              DateTime thisDay = DateTime(currentMonth.year, currentMonth.month, day);
              bool isSelected = selectedDate.year == thisDay.year &&
                  selectedDate.month == thisDay.month &&
                  selectedDate.day == thisDay.day;
              bool isToday = today.year == thisDay.year &&
                  today.month == thisDay.month &&
                  today.day == thisDay.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = thisDay;
                    widget.onDateSelected(thisDay);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : (isToday ? Colors.blueAccent : Colors.transparent),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primaryColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MiniAppointmentBox extends StatefulWidget {
  final String clientName;
  final String animal;
  final double hour;
  // Default appointment color
  final Color color;
  final VoidCallback onTap;

  const _MiniAppointmentBox({
    required this.clientName,
    required this.animal,
    required this.hour,
    this.color = AppColors.miniAppointmentColor,
    required this.onTap,
  });

  @override
  __MiniAppointmentBoxState createState() => __MiniAppointmentBoxState();
}

class __MiniAppointmentBoxState extends State<_MiniAppointmentBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 600;
    double positionInHour = widget.hour % 1;

    return Positioned(
      top: positionInHour * (isPhone ? 50 : 60),
      left: 0,
      right: 0,
      child: MouseRegion(
        onEnter: (_) => _controller.forward(),
        onExit: (_) => _controller.reverse(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: isPhone ? 45 : 55,
                    maxHeight: isPhone ? 55 : 65,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
                  padding: EdgeInsets.all(isPhone ? 2 : 4),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: widget.color.withOpacity(0.8),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: _elevationAnimation.value,
                        spreadRadius: _elevationAnimation.value / 3,
                        offset: Offset(0, _elevationAnimation.value / 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.hour.toInt()}:${(widget.hour % 1 * 60).toInt().toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: isPhone ? 9 : 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.clientName,
                        style: TextStyle(
                          fontSize: isPhone ? 9 : 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.animal,
                        style: TextStyle(
                          fontSize: isPhone ? 8 : 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PlanningDayBox extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _PlanningDayBox({
    required this.selectedDate,
    required this.onDateChanged,
    Key? key,
  }) : super(key: key);

  @override
  _PlanningDayBoxState createState() => _PlanningDayBoxState();
}

class _PlanningDayBoxState extends State<_PlanningDayBox> {
  late DateTime day;
  final List<int> hours = List.generate(11, (index) => 8 + index);
  final Color tableBorderColor = AppColors.primaryColor.withOpacity(0.5);
  final double borderWidth = 1.0;

  /// Sample appointments list.
  List<Map<String, dynamic>> appointments = [
    {
      "date": DateTime(2025, 3, 23),
      "hour": 9.0,
      "client": "Arnaud Dupont",
      "animal": "Chien",
      "phone": "06 12 34 56 78",
      "breed": "Labrador",
      "age": "3 Ans",
      "status": "NORMAL",
      "color": AppColors.miniAppointmentColor,
      "isCompleted": false,
      "isCancelled": false,
    },
    {
      "date": DateTime(2025, 3, 24),
      "hour": 10.0,
      "client": "Felix Martin",
      "animal": "Chat",
      "phone": "06 23 45 67 89",
      "breed": "Persan",
      "age": "5 Ans",
      "status": "NORMAL",
      "color": AppColors.miniAppointmentColor,
      "isCompleted": false,
      "isCancelled": false,
    },
    {
      "date": DateTime(2025, 3, 26),
      "hour": 13.5,
      "client": "Pauline Dubois",
      "animal": "Chien",
      "phone": "06 34 56 78 90",
      "breed": "Bulldog",
      "age": "2 Ans",
      "status": "NORMAL",
      "color": AppColors.miniAppointmentColor,
      "isCompleted": false,
      "isCancelled": false,
    },
    {
      "date": DateTime(2025, 3, 26),
      "hour": 18.0,
      "client": "Auline Dubois",
      "animal": "Chien",
      "phone": "06 34 56 78 90",
      "breed": "Bulldog",
      "age": "2 Ans",
      "status": "NORMAL",
      "color": AppColors.miniAppointmentColor,
      "isCompleted": false,
      "isCancelled": false,
    },
    {
      "date": DateTime(2025, 3, 26),
      "hour": 14.5,
      "client": "Marie Laurent",
      "animal": "Chat",
      "phone": "06 45 67 89 01",
      "breed": "Maine Coon",
      "age": "1 An",
      "status": "NORMAL",
      "color": AppColors.miniAppointmentColor,
      "isCompleted": false,
      "isCancelled": false,
    },
    // Sample appointments for April 9, 2025:
    {
      "date": DateTime(2025, 4, 9),
      "hour": 9.0,
      "client": "Alice Durand",
      "animal": "Chat",
      "phone": "06 33 44 55 66",
      "breed": "Siamois",
      "age": "2 Ans",
      "status": "NORMAL",
      "color": AppColors.miniAppointmentColor,
      "isCompleted": false,
      "isCancelled": false,
    },
    {
      "date": DateTime(2025, 4, 9),
      "hour": 11.0,
      "client": "Bob Martin",
      "animal": "Chien",
      "phone": "06 77 88 99 00",
      "breed": "Beagle",
      "age": "3 Ans",
      "status": "NORMAL",
      "color": AppColors.miniAppointmentColor,
      "isCompleted": false,
      "isCancelled": false,
    },
    {
      "date": DateTime(2025, 4, 9),
      "hour": 15.0,
      "client": "Claire Lefevre",
      "animal": "Oiseau",
      "phone": "06 12 00 34 56",
      "breed": "Canari",
      "age": "1 An",
      "status": "GRAVE",
      "color": AppColors.miniAppointmentColor,
      "isCompleted": false,
      "isCancelled": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    day = widget.selectedDate;
  }

  @override
  void didUpdateWidget(covariant _PlanningDayBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        day = widget.selectedDate;
      });
    }
  }

  void _changeDay(int delta) {
    setState(() {
      day = day.add(Duration(days: delta));
    });
    widget.onDateChanged(day);
  }

  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    return appointments.where((appt) {
      return appt["date"].year == day.year &&
          appt["date"].month == day.month &&
          appt["date"].day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 600;
    final double timeColumnWidth = isPhone ? 45.0 : 80.0;
    final double hourRowHeight = isPhone ? 50.0 : 60.0;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(isPhone ? 2 : 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              height: isPhone ? 40 : 50,
              decoration: BoxDecoration(
                border: Border.all(color: tableBorderColor, width: borderWidth),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: AppColors.primaryLight,
              ),
              child: Row(
                children: [
                  Container(
                    width: timeColumnWidth,
                    alignment: Alignment.center,
                    child: Text(
                      'Heure',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isPhone ? 11 : 14,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-0.5, 0),
                    child: Container(
                      height: double.infinity,
                      width: 1,
                      color: tableBorderColor,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.primaryColor,
                              size: isPhone ? 16 : 20,
                            ),
                            onPressed: () => _changeDay(-1),
                            padding: EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          DateFormat("EEE d MMM", "fr_FR").format(day),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isPhone ? 12 : 14,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: AppColors.primaryColor,
                              size: isPhone ? 16 : 20,
                            ),
                            onPressed: () => _changeDay(1),
                            padding: EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Time grid table
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: tableBorderColor, width: borderWidth),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: hours.map((hour) {
                      return Container(
                        height: hourRowHeight,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: hour < 18 ? tableBorderColor : Colors.transparent,
                              width: borderWidth,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Time column
                            Container(
                              width: timeColumnWidth,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: tableBorderColor,
                                    width: borderWidth,
                                  ),
                                ),
                                color: AppColors.primaryLight,
                              ),
                              child: Text(
                                '$hour:00',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isPhone ? 11 : 14,
                                ),
                              ),
                            ),
                            // Appointment column for the selected day
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: tableBorderColor,
                                      width: borderWidth,
                                    ),
                                  ),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: _getAppointmentsForDay(day)
                                      .where((appt) => appt["hour"].floor() == hour)
                                      .map((appt) {
                                    return _MiniAppointmentBox(
                                      clientName: appt["client"],
                                      animal: appt["animal"],
                                      hour: appt["hour"],
                                      color: appt["color"],
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AppointmentDetailsModal(
                                            clientName: appt["client"],
                                            phone: appt["phone"],
                                            animal: appt["animal"],
                                            breed: appt["breed"],
                                            age: appt["age"],
                                            status: appt["status"],
                                            initialColor: appt["color"],
                                            onColorChanged: (newColor) {
                                              setState(() {
                                                appt["color"] = newColor;
                                                if (newColor == AppColors.termineeColor) {
                                                  appt["isCompleted"] = true;
                                                  appt["isCancelled"] = false;
                                                } else if (newColor == AppColors.annuleColor) {
                                                  appt["isCompleted"] = false;
                                                  appt["isCancelled"] = true;
                                                }
                                              });
                                            },
                                            onClose: () => Navigator.pop(context),
                                            isCompleted: appt["isCompleted"] ?? false,
                                            isCancelled: appt["isCancelled"] ?? false,
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
