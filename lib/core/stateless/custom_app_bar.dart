import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/features/auth/presentation/blocs/auth_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo on the left
            Image.asset(
              'assets/images/logo.png', // Replace with your logo asset
              height: 150,
              width: 150,
fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),

            // Search bar in the center
            SizedBox(
              width: context.width*0.4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'بحث', // Arabic for "Search"
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),

            // Icons and user profile on the right
            Row(
              children: [
                // Notification Icon
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    // Add your notification logic here
                  },
                ),
                const SizedBox(width: 16),

                // User Profile
                Row(
                  children: [

                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.read<AuthBloc>().state.user!['username'], // Arabic for user name
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'مسؤول النظام', // Arabic for role
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
