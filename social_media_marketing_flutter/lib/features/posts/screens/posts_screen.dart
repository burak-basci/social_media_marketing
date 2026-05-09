import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/layouts/main_layout.dart';
import '../providers/posts_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/post_filters.dart';
import 'post_detail_dialog.dart';

/// Posts screen with list/grid view, filters, and CRUD operations.
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when scrolled 80% down
      final provider = context.read<PostsProvider>();
      if (!provider.isLoading && provider.hasMore) {
        provider.loadMorePosts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 3,
      child: Consumer<PostsProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.refreshPosts,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.paddingLG,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Posts',
                                    style: context.textTheme.headlineLarge,
                                  ),
                                  const Gap.xs(),
                                  Text(
                                    '${provider.totalPosts} ${provider.totalPosts == 1 ? 'post' : 'posts'}',
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      color: context.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // View toggle (can add list/grid toggle here)
                          ],
                        ),
                        const Gap.lg(),
                        // Filters
                        const PostFilters(),
                        const Gap.lg(),
                      ],
                    ),
                  ),
                ),

                // Error message
                if (provider.hasError && provider.posts.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: AppSpacing.paddingLG,
                      child: Card(
                        color: context.colorScheme.errorContainer,
                        child: Padding(
                          padding: AppSpacing.paddingMD,
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: context.colorScheme.onErrorContainer,
                              ),
                              const Gap.md(),
                              Expanded(
                                child: Text(
                                  provider.error ?? 'An error occurred',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                color: context.colorScheme.onErrorContainer,
                                onPressed: provider.clearError,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Posts list
                if (provider.posts.isEmpty && !provider.isLoading)
                  SliverFillRemaining(
                    child: _buildEmptyState(context, provider),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= provider.posts.length) {
                            return null;
                          }

                          final post = provider.posts[index];
                          final platforms = provider.getPostPlatforms(post);
                          final content = provider.getPostContent(post);

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: PostCard(
                              post: post,
                              platforms: platforms,
                              content: content,
                              onTap: () => _showPostDetail(context, post),
                              onEdit: () => _showPostDetail(context, post),
                              onDuplicate: () => _duplicatePost(context, post),
                              onPublishNow: () => _publishNow(context, post),
                              onDelete: () => _deletePost(context, post),
                            ),
                          );
                        },
                        childCount: provider.posts.length,
                      ),
                    ),
                  ),

                // Loading indicator
                if (provider.isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: AppSpacing.paddingLG,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),

                // Load more button
                if (!provider.isLoading &&
                    provider.hasMore &&
                    provider.posts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: AppSpacing.paddingLG,
                      child: Center(
                        child: OutlinedButton(
                          onPressed: provider.loadMorePosts,
                          child: const Text('Load More'),
                        ),
                      ),
                    ),
                  ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: Gap.xl(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, PostsProvider provider) {
    final hasFilters = provider.hasActiveFilters;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.post_add_outlined,
            size: 64,
            color: context.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const Gap.md(),
          Text(
            hasFilters ? 'No posts match your filters' : 'No posts yet',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const Gap.xs(),
          Text(
            hasFilters
                ? 'Try adjusting your filters'
                : 'Create your first campaign to get started',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          if (hasFilters) ...[
            const Gap.lg(),
            OutlinedButton.icon(
              onPressed: provider.clearFilters,
              icon: const Icon(Icons.clear),
              label: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showPostDetail(BuildContext context, Post post) async {
    await showDialog(
      context: context,
      builder: (context) => PostDetailDialog(post: post),
    );
  }

  Future<void> _duplicatePost(BuildContext context, Post post) async {
    final provider = context.read<PostsProvider>();

    try {
      await provider.duplicatePost(post.id!);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post duplicated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to duplicate post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _publishNow(BuildContext context, Post post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publish Now'),
        content: const Text(
          'Are you sure you want to publish this post immediately?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Publish'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final provider = context.read<PostsProvider>();

    try {
      await provider.publishNow(post.id!);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post published successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to publish post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deletePost(BuildContext context, Post post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final provider = context.read<PostsProvider>();

    try {
      await provider.deletePost(post.id!);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
