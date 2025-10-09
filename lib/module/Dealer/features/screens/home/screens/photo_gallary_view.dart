import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';

class PhotoGallaryView extends StatefulWidget {
  List<Map<String, String>> images;
  final int currentImageIndex;
  PhotoGallaryView({
    super.key,
    required this.currentImageIndex,
    required this.images,
  });

  @override
  State<PhotoGallaryView> createState() => _PhotoGallaryViewState();
}

class _PhotoGallaryViewState extends State<PhotoGallaryView> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentImageIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            onPageChanged: (index) {
              currentIndex = index;
              setState(() {});
            },
            pageController: _pageController,
            itemCount: widget.images.length,
            builder:
                (context, index) => PhotoViewGalleryPageOptions(
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.images[index],
                  ),
                  gestureDetectorBehavior: HitTestBehavior.translucent,
                  imageProvider: CachedNetworkImageProvider(
                    widget.images[index]['image'] ?? "",
                  ),
                ),
          ),

          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VCustomBackbutton(),
                AppMargin(
                  child: Text(
                    "${currentIndex + 1}/${widget.images.length}",
                    style: VStyle.style(
                      context: context,
                      color: VColors.WHITE,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            right: 5,
            left: 5,
            child: Container(
              width: w(context),
              color: VColors.DARK_GREY.withAlpha(130),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    widget.images[currentIndex]['title']!
                        .split(",")
                        .map(
                          (e) => Text(
                            "∙ $e",
                            style: EvAppStyle.style(
                              context: context,
                              color: EvAppColors.white,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
