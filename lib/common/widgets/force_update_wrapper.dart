import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:wheels_kart/common/config/app_config.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';

class ForceUpdateWrapper extends StatefulWidget {
  final Widget child;
  
  const ForceUpdateWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ForceUpdateWrapper> createState() => _ForceUpdateWrapperState();
}

class _ForceUpdateWrapperState extends State<ForceUpdateWrapper> {
  @override
  void initState() {
    super.initState();
    // Check for updates when wrapper is initialized (only if enabled)
    if (AppConfig.forceUpdateEnabled) {
      _checkForUpdate();
    }
  }

  Future<void> _checkForUpdate() async {
    try {
      final newVersion = NewVersionPlus(
        androidId: "com.crisant.wheelskart",
        iOSId: "6749476545",
      );

      final status = await newVersion.getVersionStatus();

      if (status?.canUpdate == true && mounted) {
        // Show force update dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.system_update,
                  color: EvAppColors.DEFAULT_BLUE_DARK,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Update Required",
                    style: EvAppStyle.style(
                      context: context,
                      size: 20,
                      fontWeight: FontWeight.bold,
                      color: EvAppColors.DEFAULT_BLUE_DARK,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please update to the latest version to continue using Wheels Kart.",
                  style: EvAppStyle.style(
                    context: context,
                    size: 16,
                    color: EvAppColors.DEFAULT_BLUE_DARK,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: EvAppColors.DEFAULT_BLUE_DARK,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "This update includes important improvements and bug fixes.",
                          style: EvAppStyle.style(
                            context: context,
                            size: 14,
                            color: EvAppColors.DEFAULT_BLUE_DARK,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (status?.appStoreLink != null) {
                      newVersion.launchAppStore(status!.appStoreLink);
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text("Update Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error checking for updates: $e");
      // Continue with app flow even if update check fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}