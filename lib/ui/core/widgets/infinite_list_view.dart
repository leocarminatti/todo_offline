import 'package:flutter/material.dart';

import '../../ui.dart';

typedef ItemBuilder<T> = Widget Function(T item);

class InfiniteListView<T> extends StatefulWidget {
  final List<T> items;
  final VoidCallback onLoadMore;
  final ItemBuilder<T> itemBuilder;
  final bool hasMore;

  const InfiniteListView({
    super.key,
    required this.items,
    required this.onLoadMore,
    required this.itemBuilder,
    required this.hasMore,
  });

  @override
  _InfiniteListViewState<T> createState() => _InfiniteListViewState<T>();
}

class _InfiniteListViewState<T> extends State<InfiniteListView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.hasMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.items.isEmpty
        ? const EmptyStateWidget(
            message: 'Nenhuma tarefa concluída ainda.',
          )
        : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount:
                widget.hasMore ? widget.items.length + 1 : widget.items.length,
            itemBuilder: (context, index) {
              if (widget.hasMore && index == widget.items.length) {
                return Loading();
              }
              return widget.itemBuilder(widget.items[index]);
            },
          );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
