import 'package:flutter/material.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/decision_screen.dart';

class AccountDeletionSuccessScreen extends StatelessWidget {
  const AccountDeletionSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green.shade600,
                ),
              ),

              const SizedBox(height: 32),

              // Success Title
              Text(
                'Account Deleted Successfully',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Success Message
              Text(
                'Your account has been permanently deleted. All your data has been removed from our servers.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Additional Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Thank you for using our app. We\'re sorry to see you go!',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Action Buttons
              Column(
                children: [
                  // Close App Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Close the app or navigate to login/welcome screen
                        Navigator.of(context).pushAndRemoveUntil(
                          AppRoutes.createRoute(DecisionScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Optional: Feedback Button
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 50,
                  //   child: OutlinedButton(
                  //     onPressed: () {
                  //       // Navigate to feedback screen or show feedback dialog
                  //       _showFeedbackDialog(context);
                  //     },
                  //     style: OutlinedButton.styleFrom(
                  //       foregroundColor: Colors.grey.shade700,
                  //       side: BorderSide(
                  //         color: Colors.grey.shade400,
                  //         width: 1.5,
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Give Feedback',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback'),
          content: const Text(
            'We value your feedback. Would you like to tell us why you deleted your account?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Not now'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to feedback form or open email client
                // You can implement your feedback mechanism here
              },
              child: const Text('Give Feedback'),
            ),
          ],
        );
      },
    );
  }
}
