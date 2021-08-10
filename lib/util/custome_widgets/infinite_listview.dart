import 'dart:developer';

import 'package:flutter/material.dart';

import '../utility/global_var.dart';
import 'messages.dart';

class InfiniteListview extends StatefulWidget {
  final List<dynamic> dataList;
  final int nextPageThreshold;
  final Function(int page) loadDataFunction;
  final Function(dynamic item) listItemWidget;
  final Widget noDataAvilable;

  InfiniteListview({this.dataList, this.loadDataFunction, this.listItemWidget, this.nextPageThreshold = 5, this.noDataAvilable});

  // get dataList => _InfiniteListviewState().dataList;

  @override
  _InfiniteListviewState createState() => _InfiniteListviewState();
}

class _InfiniteListviewState extends State<InfiniteListview> {
  int page = 0;
  bool _isLoading = true;
  bool _isMoreAvailable = true;

  @override
  void initState() {
    Future.microtask(() {
      loadDataList(0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => loadDataList(0),
      child: ListView.builder(
        itemCount: widget.dataList.length + 1,
        itemBuilder: (ctx, index) {
          if (index == widget.dataList.length - widget.nextPageThreshold && _isMoreAvailable) {
            log('///////////////////////////////  loadDataList more ');
            _isLoading = true;
            loadDataList(++page);
          }
          if (index == widget.dataList.length) if (_isLoading)
            return Padding(padding: const EdgeInsets.all(8.0), child: Center(child: CircularProgressIndicator()));
          else if (widget.dataList.length == 0)
            return widget.noDataAvilable ?? ErrorCustomWidget(str.msg.noDataAvailable, showErrorWord: false);
          else
            return SizedBox();
          return widget.listItemWidget(widget.dataList[index]);
        },
      ),
    );
  }

  Future<void> loadDataList(int page) async {
    try {
      _isLoading = true;
      if (page == 0) resetSetting();

      List<dynamic> list = await widget.loadDataFunction(page);
      if (page == 0) widget.dataList.clear();
      setState(() {
        widget.dataList.insertAll(widget.dataList.length, list);
        _isLoading = false;
        if (list.length == 0) _isMoreAvailable = false;
      });
    } catch (err) {
      print(err.toString());
    }
    _isLoading = false;
  }

  void resetSetting() {
    page = 0;
    _isMoreAvailable = true;
  }

  void setIsLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }
}

class InfiniteSliverList extends StatefulWidget {
  final List<dynamic> dataList;
  final int nextPageThreshold;
  final Function(int page) loadDataFunction;
  final Function(dynamic item) listItemWidget;
  final bool showNoDataMsg;

  InfiniteSliverList({this.dataList, this.loadDataFunction, this.listItemWidget, this.nextPageThreshold = 5, this.showNoDataMsg = true});

  // get dataList => _InfiniteListviewState().dataList;

  @override
  _InfiniteSliverListState createState() => _InfiniteSliverListState();
}

class _InfiniteSliverListState extends State<InfiniteSliverList> {
  int page = 0;
  bool _isLoading = true;
  bool _isMoreAvailable = true;

  @override
  void initState() {
    Future.microtask(() {
      loadDataList(0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == widget.dataList.length - widget.nextPageThreshold && _isMoreAvailable) {
          _isLoading = true;
          loadDataList(++page);
        }
        if (index == widget.dataList.length) if (_isLoading)
          return Padding(padding: const EdgeInsets.all(8.0), child: Center(child: CircularProgressIndicator()));
        else if (widget.dataList.length == 0)
          return widget.showNoDataMsg ? ErrorCustomWidget(str.msg.noDataAvailable, showErrorWord: false) : SizedBox();
        else
          return SizedBox();
        return widget.listItemWidget(widget.dataList[index]);
      }, childCount: widget.dataList.length + 1),
    );
  }

  Future<void> loadDataList(int page) async {
    try {
      _isLoading = true;
      if (page == 0) resetSetting();

      List<dynamic> list = await widget.loadDataFunction(page);
      if (page == 0) widget.dataList.clear();
      if (mounted)
        setState(() {
          widget.dataList.insertAll(widget.dataList.length, list);
          _isLoading = false;
          if (list.length == 0) _isMoreAvailable = false;
        });
    } catch (err) {
      print(err.toString());
    }
    setIsLoading(false);
  }

  void resetSetting() {
    page = 0;
    _isMoreAvailable = true;
  }

  void setIsLoading(bool value) {
    if (mounted)
      setState(() {
        _isLoading = value;
      });
  }
}
