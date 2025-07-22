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
  const ProfileHeaderCard({ super.key});

  @override
  State<ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends State<ProfileHeaderCard> {
   @override
  void initState() {
    super.initState();
    // Load user profile when screen initializes
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
    return Consumer<AuthProvider>(builder: (context,provider,child){
      final user = provider.user;
      if(provider.isLoading){
        return Center(child: CircularProgressIndicator());
      }else{
       return   Row(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundImage: AssetImage(user!.profilePic),
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
            '@${user.email }',
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
    });
  }
}
