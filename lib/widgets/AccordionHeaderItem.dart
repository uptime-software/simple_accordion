import 'package:flutter/material.dart';
import 'package:simple_accordion/model/SimpleAccordionState.dart';
import 'package:simple_accordion/widgets/AccordionItem.dart';

class AccordionHeaderItem extends StatefulWidget {
  AccordionHeaderItem(
      {this.isOpen,
      Key? key,
      this.title,
      required this.children,
      this.child,
      this.headerColor,
      this.index = 0,
      this.headerTextStyle,
      this.itemTextStyle,
      this.itemColor,
      this.separatorColor,
      this.separatorSize,
      this.iconColor,
      this.icon,
      this.headerPadding,
      this.headerBorderRadius,
      this.spacing})
      : assert(title != null || child != null),
        super(key: key);

  /// set default state of header (open/close)
  final bool? isOpen;
  final String? title;
  final Widget? child;
  final List<AccordionItem> children;

  /// set the color of header
  Color? headerColor;

  /// set the color of current header items
  Color? itemColor;

  /// don't use this property, it'll use to another feature
  int index;

  /// if you're using title instead of child in AccordionHeaderItem
  TextStyle? headerTextStyle;

  /// if you're using title instead of child in AccordionItem
  TextStyle? itemTextStyle;

  /// set the color of separator line
  Color? separatorColor;

  /// set the size of separator line
  double? separatorSize;

  /// set the color of chevron icon
  Color? iconColor;

  /// set a custom icon instead of chevron icon
  Icon? icon;

  /// set padding of header
  EdgeInsetsGeometry? headerPadding;

  /// set border radius of header
  BorderRadiusGeometry? headerBorderRadius;

  /// set spacing between headers
  double? spacing;

  @override
  State<StatefulWidget> createState() => _AccordionHeaderItem();
}

class _AccordionHeaderItem extends State<AccordionHeaderItem> {
  final Color defaultColor = const Color(0xffd4d4d4);

  late bool isOpen;

  @override
  void initState() {
    isOpen = widget.isOpen ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = SimpleAccordionState.of(context);
    final header = InkWell(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: ClipRRect(
        borderRadius: widget.headerBorderRadius ?? BorderRadius.zero,
        child: Container(
          margin: EdgeInsets.only(top: widget.spacing ?? 0),
          padding: widget.headerPadding ??
              const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            color: widget.headerColor,
            border: Border(
              bottom: BorderSide(
                color: widget.separatorColor ?? defaultColor,
                width: widget.separatorSize ?? 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: widget.child ??
                    Text(
                      widget.title!,
                      style: widget.headerTextStyle,
                    ),
              ),
              widget.icon ??
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    color: widget.iconColor ?? defaultColor,
                  )
            ],
          ),
        ),
      ),
    );
    return AnimatedCrossFade(
      crossFadeState:
          isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
      firstChild: header,
      secondChild: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          Container(
            color: widget.itemColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children
                  .map((e) => e
                    ..indexGroup = widget.index
                    ..checked = e.checked ??
                        (state?.selectedItems ?? [])
                            .any((w) => w.title == e.title)
                    ..itemTextStyle = e.itemTextStyle ?? widget.itemTextStyle)
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
