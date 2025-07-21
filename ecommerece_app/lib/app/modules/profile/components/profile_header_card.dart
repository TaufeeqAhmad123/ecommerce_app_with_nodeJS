import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ecommerece_app/app/data/constants/constants.dart';
import 'package:ecommerece_app/app/models/user_model.dart';
import 'package:ecommerece_app/app/modules/profile/edit_profile.dart';

class ProfileHeaderCard extends StatelessWidget {
  final User user;
  const ProfileHeaderCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundImage: AssetImage(user.profilePic),
        ),
        SizedBox(
          width: AppSpacing.tenHorizontal,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(user.name, style: AppTypography.kSemiBold18),
          SizedBox(height: AppSpacing.fiveVertical),
          Text(
            '@${user.location}',
            style: AppTypography.kMedium14.copyWith(
              color: AppColors.kGrey60,
            ),
          ),
        ],),
        const Spacer(),
        IconButton(
          icon: SvgPicture.asset(AppAssets.kEdit),
          onPressed: () {
            Get.to<Widget>(()=>const EditProfile());
          },
        ),
      ],
    );
  }
}
