import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'details_modal.dart';

void main() {
  runApp(MaterialApp(
    home: RDVScreen(),
    theme: ThemeData(
      dialogTheme: DialogTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ),
  ));
}

class RDVScreen extends StatefulWidget {
  @override
  _RDVScreenState createState() => _RDVScreenState();
}

class _RDVScreenState extends State<RDVScreen> {
  DateTime selectedDate = DateTime.now();
  bool isCalendarVisible = true;

  @override
  Widget build(BuildContext context) {
    _getWeekStart(selectedDate);
    // Check if device is phone (e.g. width less than 600)
    bool isPhone = MediaQuery.of(context).size.width < 600;

    if (isPhone) {
      // Phone layout: planning week takes full screen and mini calendar overlays it (with masking)
      return Scaffold(
        backgroundColor: Colors.green[50],
        body: Stack(
          children: [
            // Full screen planning week box
            Positioned.fill(
              child: _PlanningWeekBox(
                selectedDate: selectedDate,
                key: ValueKey<DateTime>(selectedDate),
              ),
            ),
            // Overlay the mini calendar when visible (it uses almost full width)
            if (isCalendarVisible)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.95), // Masking effect
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
            // Toggle button (positioned at top right) - ONLY CHANGE IS HERE
            Positioned(
              top: isPhone ? 30 : 10, // Changed from 10 to 30 for phones
              right: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isCalendarVisible = !isCalendarVisible;
                  });
                },
                child: Container(
                  width: isPhone ? 40:30,
                  height: isPhone ? 40:30,
                  
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),)
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
                      size: isPhone ? 24 : 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // PC layout (unchanged)
      return Scaffold(
        backgroundColor: Colors.green[50],
        body: Stack(
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
                    color: Colors.green[100],
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

                // Main content area
                Expanded(
                  child: AnimatedPadding(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.only(left: isCalendarVisible ? 0 : 0),
                    child: Column(
                      children: [
                        _PlanningWeekBox(
                          selectedDate: selectedDate,
                          key: ValueKey<DateTime>(selectedDate),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Toggle button (unchanged for PC)
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
                    color: Colors.green,
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
      );
    }
  }

  DateTime _getWeekStart(DateTime date) {
    int dayOfWeek = date.weekday;
    return date.subtract(Duration(days: dayOfWeek - 1));
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

    return Center( // Wrapped with Center widget for phone screens
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
            offset: Offset(0, 4),)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.green),
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
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.green),
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
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              );
            }).toList(),
          ),
          Divider(
            color: Colors.green,
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
                        ? Colors.green
                        : (isToday ? Colors.blueAccent : Colors.transparent),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.green.withOpacity(0.5)),
                  ),
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.green[900],
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
  final Color color;
  final VoidCallback onTap;

  const _MiniAppointmentBox({
    required this.clientName,
    required this.animal,
    required this.hour,
    this.color = const Color(0xFF2196F3),
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
      top: positionInHour * (isPhone ? 50 : 60), // Adjusted for phone
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
class _PlanningWeekBox extends StatefulWidget {
  final DateTime selectedDate;

  const _PlanningWeekBox({
    required this.selectedDate, 
    Key? key,
  }) : super(key: key);

  @override
  _PlanningWeekBoxState createState() => _PlanningWeekBoxState();
}

class _PlanningWeekBoxState extends State<_PlanningWeekBox> {
  late DateTime weekStartDate;
  final List<int> hours = List.generate(11, (index) => 8 + index);
  final Color tableBorderColor = Colors.green.withOpacity(0.5);
  final double borderWidth = 1.0;

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
      "color": const Color(0xFF2196F3),
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
      "color": const Color(0xFF2196F3),
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
      "color": const Color(0xFF2196F3),
    },
        {
      "date": DateTime(2025, 3, 26), 
      "hour": 18.0, 
      "client": "auline Dubois", 
      "animal": "Chien",
      "phone": "06 34 56 78 90",
      "breed": "Bulldog",
      "age": "2 Ans",
      "status": "NORMAL",
      "color": const Color(0xFF2196F3),
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
      "color": const Color(0xFF2196F3),
    },
  ];

  @override
  void initState() {
    super.initState();
    weekStartDate = _getWeekStart(widget.selectedDate);
  }

  @override
  void didUpdateWidget(covariant _PlanningWeekBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      weekStartDate = _getWeekStart(widget.selectedDate);
    }
  }

  DateTime _getWeekStart(DateTime date) {
    int dayOfWeek = date.weekday % 7;
    return date.subtract(Duration(days: dayOfWeek));
  }

  void _changeWeek(int days) {
    setState(() {
      weekStartDate = weekStartDate.add(Duration(days: days));
    });
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
    final double timeColumnWidth = isPhone ? 45.0 : 80.0; // Reduced from 60 to 45 for phones
    final double hourRowHeight = isPhone ? 50.0 : 60.0;
    
    List<String> frenchDayNames = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
    
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(isPhone ? 2 : 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: isPhone ? 45.0 : 0.0),
          child: Column(
            children: [
              // Week changer with circular buttons
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: tableBorderColor, width: borderWidth),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green[50],
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isPhone ? 6 : 8,
                  horizontal: isPhone ? 8 : 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button with circular border
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: tableBorderColor, width: borderWidth),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, 
                            color: Colors.green,
                            size: isPhone ? 20 : 24),
                        onPressed: () => _changeWeek(-7),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    
                    // Week range text (without year)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: isPhone ? 8 : 16),
                      child: Text(
                        '${DateFormat('d MMM', 'fr_FR').format(weekStartDate)} - '
                        '${DateFormat('d MMM', 'fr_FR').format(weekStartDate.add(const Duration(days: 6)))}',
                        style: TextStyle(
                          fontSize: isPhone ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                    ),
                    
                    // Forward button
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: tableBorderColor, width: borderWidth),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward, 
                            color: Colors.green,
                            size: isPhone ? 20 : 24),
                        onPressed: () => _changeWeek(7),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isPhone ? 5 : 10),

              // Days header
              Container(
                height: isPhone ? 40 : 50,
                decoration: BoxDecoration(
                  border: Border.all(color: tableBorderColor, width: borderWidth),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  color: Colors.green[50],
                ),
                child: Row(
                  children: [
                    // Time column header - now narrower
                    Container(
                      width: timeColumnWidth,
                      alignment: Alignment.center,
                      child: Text(
                        'Heure',
                        style: TextStyle(
                          color: Colors.green[900],
                          fontWeight: FontWeight.bold,
                          fontSize: isPhone ? 11 : 14, // Smaller font for phone
                        ),
                      ),
                    ),
                    
                    // Empty column separator
                    Container(
                      width: borderWidth,
                      color: tableBorderColor,
                    ),
                    
                    // Day columns - now have more space
                    ...List.generate(7, (index) {
                      DateTime day = weekStartDate.add(Duration(days: index));
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide(
                              color: tableBorderColor,
                              width: borderWidth,
                            )),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${frenchDayNames[index]}\n${day.day}', // Added line break
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isPhone ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Time grid table
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: tableBorderColor, width: borderWidth),
                      borderRadius: const BorderRadius.only(
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
                              // Time column - now narrower
                              Container(
                                width: timeColumnWidth,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(right: BorderSide(
                                    color: tableBorderColor,
                                    width: borderWidth,
                                  )),
                                  color: Colors.green[50],
                                ),
                                child: Text(
                                  '$hour:00',
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: isPhone ? 11 : 14, // Smaller font
                                  ),
                                ),
                              ),
                              
                              // Empty column separator
                              Container(
                                width: borderWidth,
                                color: tableBorderColor,
                              ),
                              
                              // Day columns - now wider
                              ...List.generate(7, (dayIndex) {
                                DateTime day = weekStartDate.add(Duration(days: dayIndex));
                                var dayAppointments = _getAppointmentsForDay(day);
                                var cellAppointments = dayAppointments.where((appt) => appt["hour"].floor() == hour).toList();
                                
                                return Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(right: BorderSide(
                                        color: tableBorderColor,
                                        width: borderWidth,
                                      )),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: cellAppointments.map((appt) {
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
                                                    appt["isCompleted"] = newColor == Colors.green;
                                                    appt["isCancelled"] = newColor == Colors.red;
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
                                );
                              }),
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
      ),
    );
  }
}