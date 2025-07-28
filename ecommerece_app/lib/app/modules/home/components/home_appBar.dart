import 'package:ecommerece_app/app/modules/widgets/shimmer/app_shimmer.dart';
import 'package:ecommerece_app/app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ecommerece_app/app/data/constants/constants.dart';
import 'package:ecommerece_app/app/modules/checkout/cart_view.dart';
import 'package:ecommerece_app/app/modules/notification/notification_view.dart';
import 'package:ecommerece_app/app/modules/profile/edit_profile.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getUSerProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 60.w,
      leading: GestureDetector(
        onTap: () {
          Get.to<Widget>(() => const EditProfile());
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, top: 5.h),
          child: Consumer<AuthProvider>(
            builder: (builder, provider, child) {
              final user = provider.user;
              if (provider.isLoading) {
                return AppShimmer(
                  width: 100.w,
                  height: 20.h,
                  shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(10.r),
                );
              } else {
                if (user?.profilePic == null ||
                    user!.profilePic.trim().isEmpty) {
                  return CircleAvatar(
                    radius: 20.r,
                    child: Text(
                      user!.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    ),
                  );
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                     child: CachedNetworkImage(
                   imageUrl:    user.profilePic,
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: 20.r,
                          backgroundImage: imageProvider,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                          radius: 20.r,
                          child: Text(user.name[0].toUpperCase()),
                        );
                      },),
                     
                   
                  );
                }
              }
            },
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<AuthProvider>(
            builder: (builder, provider, child) {
              final user = provider.user;
              if (provider.isLoading) {
                return AppShimmer(
                  width: 100.w,
                  height: 20.h,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.r),
                );
              }
              return Text(
                user!.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.kGrey100,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          Text(
            'Good Morning',
            style: AppTypography.kLight10.copyWith(color: AppColors.kGrey80),
          ),
        ],
      ),
      actions: [
        CustomIcons(
          onTap: () {
            Get.to<Widget>(CartView.new);
          },
          icon: AppAssets.kBag,
        ),
        SizedBox(width: 10.0.w),
        CustomIcons(
          onTap: () {
            Get.to<Widget>(() => const NotificationView());
          },
          icon: AppAssets.kNotification,
        ),
        SizedBox(width: 20.0.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomIcons extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const CustomIcons({required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        width: 44.w,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffF6F6F6),
        ),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
