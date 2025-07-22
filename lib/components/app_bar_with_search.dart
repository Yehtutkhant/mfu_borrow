import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSize {
  final TextEditingController searchController;
  final Function? showFilterOptions;
  final String title;
  final String searchText;
  final double leftPadding;

  final bool homeSearch;
  final VoidCallback? onChanged;

  const SearchAppBar({
    super.key,
    this.homeSearch = false,
    required this.leftPadding,
    required this.searchText,
    required this.title,
    required this.searchController,
    this.showFilterOptions,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(130),
      child: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        flexibleSpace: Padding(
          padding: EdgeInsets.fromLTRB(leftPadding, 60, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (_) {
                        if (onChanged != null) onChanged!();
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.search),
                        hintText: searchText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  !homeSearch
                      ? IconButton(
                          icon: Icon(Icons.tune,
                              color: Theme.of(context).colorScheme.primary),
                          onPressed: () => {
                            if (showFilterOptions != null) showFilterOptions!()
                          },
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
