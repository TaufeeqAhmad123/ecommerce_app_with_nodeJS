import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerece_app/app/modules/widgets/shimmer/app_shimmer.dart';
import 'package:ecommerece_app/app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ecommerece_app/app/data/constants/constants.dart';
import 'package:ecommerece_app/app/models/user_model.dart';
import 'package:ecommerece_app/app/modules/profile/edit_profile.dart';
import 'package:provider/provider.dart';

class ProfileHeaderCard extends StatefulWidget {
  const ProfileHeaderCard({super.key});

  @override
  State<ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends State<ProfileHeaderCard> {
  @override
  void initState() {
    super.initState();
    // Load user profile when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
     final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) {
      _loadUserProfile();
    }
    });
  }

  Future<void> _loadUserProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getUSerProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        final user = provider.user;
        if (provider.isLoading) {
          return Row(
            children: [
              AppShimmer(width: 80.w, height: 80.h, shape: BoxShape.circle),
              SizedBox(width: AppSpacing.twentyHorizontal),
              Column(
                children: [
                  AppShimmer(
                    width: 200.w,
                    height: 20.h,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  SizedBox(height: AppSpacing.tenVertical),
                  AppShimmer(
                    width: 200.w,
                    height: 20.h,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Row(
            children: [
              if (user!.profilePic.isNotEmpty)
                Stack(
                  children: [
                  CircleAvatar(
                    radius: 40.r,
                        child: authProvider.profileImage != null
              ? ClipOval(
                  child: Image.file(
                    File(authProvider.profileImage!.path),
                    fit: BoxFit.cover,
                    width: 80.r,
                    height: 80.r,
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: user.profilePic,
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                      radius: 40.r,
                      backgroundImage: imageProvider,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return CircleAvatar(
                      child: Text(user.name[0].toUpperCase()),
                    );
                  },
                ),
                  ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          await authProvider.pickProfileImage();
                          if (authProvider.profileImage != null) {
                            await authProvider.uploadProfileImage();
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please select an image first',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(user.name, style: AppTypography.kSemiBold18),
                  ),
                  SizedBox(height: AppSpacing.fiveVertical),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      '@${user.email}',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey60,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: SvgPicture.asset(AppAssets.kEdit),
                onPressed: () {
                  Get.to<Widget>(() => const EditProfile());
                },
              ),
            ],
          );
        }
      },
    );
  }
}
