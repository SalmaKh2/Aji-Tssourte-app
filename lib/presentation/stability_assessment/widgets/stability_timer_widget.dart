import 'package:flutter/material.dart';

class StabilityTimerWidget extends StatefulWidget {
  final int duration; // en secondes
  final VoidCallback onTimerComplete;
  final Color color;

  const StabilityTimerWidget({
    super.key,
    required this.duration,
    required this.onTimerComplete,
    required this.color,
  });

  @override
  State<StabilityTimerWidget> createState() => _StabilityTimerWidgetState();
}

class _StabilityTimerWidgetState extends State<StabilityTimerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );
    
    _controller
      ..addListener(() {
        setState(() {
          _remainingTime = widget.duration - (_controller.value * widget.duration).toInt();
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onTimerComplete();
        }
      });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Cercle de fond
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(0.1),
              ),
            ),
            
            // Cercle de progression
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                value: _controller.value,
                strokeWidth: 10,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
              ),
            ),
            
            // Temps restant
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_remainingTime',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'secondes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Instructions pendant le timer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                'Maintenez la position\njusqu\'à la fin du timer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Bouton pour terminer prématurément
        OutlinedButton(
          onPressed: () {
            _controller.stop();
            widget.onTimerComplete();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
          child: const Text('Terminer plus tôt'),
        ),
      ],
    );
  }
}
