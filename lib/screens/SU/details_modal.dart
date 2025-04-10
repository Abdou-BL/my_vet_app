import 'package:flutter/material.dart';
import '../../widgets/colors.dart';


class AppointmentDetailsModal extends StatefulWidget {
  final String clientName;
  final String phone;
  final String animal;
  final String breed;
  final String age;
  final String status;
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onClose;
  final bool isCompleted;
  final bool isCancelled;

  const AppointmentDetailsModal({
    super.key,
    required this.clientName,
    required this.phone,
    required this.animal,
    required this.breed,
    required this.age,
    required this.status,
    required this.initialColor,
    required this.onColorChanged,
    required this.onClose,
    this.isCompleted = false,
    this.isCancelled = false,
  });

  @override
  State<AppointmentDetailsModal> createState() =>
      _AppointmentDetailsModalState();
}

class _AppointmentDetailsModalState extends State<AppointmentDetailsModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late bool _actionTaken;
  late String _actionMessage;
  bool _isCloseHovered = false;

  @override
  void initState() {
    super.initState();
    // Read persistent appointment state so that when reopening,
    // the action message remains and the buttons are not shown.
    _actionTaken = widget.isCompleted || widget.isCancelled;
    _actionMessage =
        widget.isCompleted ? 'Terminé' : widget.isCancelled ? 'Annulé' : '';

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen dimensions for responsive design.
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPhoneScreen = screenWidth < 600;
    final double containerWidth =
        isPhoneScreen ? screenWidth * 0.95 : screenWidth * 0.9;
    final BoxConstraints containerConstraints = isPhoneScreen
        ? const BoxConstraints()
        : const BoxConstraints(maxWidth: 500);
    final EdgeInsets containerPadding =
        isPhoneScreen ? const EdgeInsets.all(15) : const EdgeInsets.all(25);

    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: containerWidth,
              constraints: containerConstraints,
              padding: containerPadding,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modal title and underline
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Détails du rendez-vous',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 2,
                            color: AppColors.primaryColor,
                            margin: const EdgeInsets.only(bottom: 15),
                          ),
                        ],
                      ),
                      ...List<Widget>.generate(6, (index) {
                        return AnimatedDetailRow(
                          delay: index * 100,
                          label: _getLabelForIndex(index),
                          value: _getValueForIndex(index),
                          child: index == 5 ? _buildStatusWidget() : null,
                        );
                      }),
                      const SizedBox(height: 25),
                      // Show either the action message or the buttons.
                      if (_actionTaken)
                        _buildActionStatusMessage()
                      else
                        AnimatedButtonRow(
                          delay: 600,
                          onMarkComplete: () {
                            setState(() {
                              _actionTaken = true;
                              _actionMessage = 'Terminé';
                            });
                            widget.onColorChanged(AppColors.termineeColor);
                          },
                          onCancel: () {
                            setState(() {
                              _actionTaken = true;
                              _actionMessage = 'Annulé';
                            });
                            widget.onColorChanged(AppColors.annuleColor);
                          },
                        ),
                    ],
                  ),
                  // Close button in the top right corner.
                  // For PC screens, a larger hit area with hover animation is provided.
                  Positioned(
                    top: -10,
                    right: -10,
                    child: isPhoneScreen
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: widget.onClose,
                            splashRadius: 20,
                          )
                        : MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _isCloseHovered = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _isCloseHovered = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: widget.onClose,
                              behavior: HitTestBehavior.translucent,
                              child: AnimatedScale(
                                scale: _isCloseHovered ? 1.2 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(Icons.close),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionStatusMessage() {
    final bool isComplete = _actionMessage == 'Terminé';
    final Color displayColor = isComplete ?  AppColors.termineeColor : AppColors.annuleColor;

    return Container(
      height: 48,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: displayColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: displayColor,
          width: 1.5,
        ),
      ),
      child: Text(
        _actionMessage,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: displayColor,
        ),
      ),
    );
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Client';
      case 1:
        return 'Téléphone';
      case 2:
        return 'Animal';
      case 3:
        return 'Race';
      case 4:
        return 'Âge';
      case 5:
        return 'État';
      default:
        return '';
    }
  }

  String? _getValueForIndex(int index) {
    switch (index) {
      case 0:
        return widget.clientName;
      case 1:
        return widget.phone;
      case 2:
        return '${widget.animal} (Female)';
      case 3:
        return widget.breed;
      case 4:
        return widget.age;
      default:
        return null;
    }
  }

  Widget _buildStatusWidget() {
    final bool isNormal = widget.status.toLowerCase() == 'normal';
    final Color statusColor = isNormal ?  AppColors.termineeColor :AppColors.annuleColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class AnimatedDetailRow extends StatefulWidget {
  final String label;
  final String? value;
  final Widget? child;
  final int delay;

  const AnimatedDetailRow({
    super.key,
    required this.label,
    this.value,
    this.child,
    required this.delay,
  });

  @override
  State<AnimatedDetailRow> createState() => _AnimatedDetailRowState();
}

class _AnimatedDetailRowState extends State<AnimatedDetailRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: widget.child ??
                    Text(
                      widget.value!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButtonRow extends StatefulWidget {
  final VoidCallback onMarkComplete;
  final VoidCallback onCancel;
  final int delay;

  const AnimatedButtonRow({
    super.key,
    required this.onMarkComplete,
    required this.onCancel,
    required this.delay,
  });

  @override
  State<AnimatedButtonRow> createState() => _AnimatedButtonRowState();
}

class _AnimatedButtonRowState extends State<AnimatedButtonRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPhoneScreen = MediaQuery.of(context).size.width < 600;
    final double verticalPadding = isPhoneScreen ? 10.0 : 14.0;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Row(
          children: [
            // "Terminer" button
            Expanded(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.termineeColor,
                    padding: EdgeInsets.symmetric(vertical: verticalPadding),
                    elevation: 0,
                    shadowColor: AppColors.termineeColor.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ).copyWith(
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return 4;
                        }
                        return 0;
                      },
                    ),
                  ),
                  onPressed: widget.onMarkComplete,
                  child: const Text(
                    'Terminer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // "Annuler" button
            Expanded(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  AppColors.annuleColor,
                    padding: EdgeInsets.symmetric(vertical: verticalPadding),
                    elevation: 0,
                    shadowColor: AppColors.annuleColor.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ).copyWith(
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return 4;
                        }
                        return 0;
                      },
                    ),
                  ),
                  onPressed: widget.onCancel,
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
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
