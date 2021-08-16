import 'package:awesome_notifications/src/enumerators/notification_privacy.dart';
import 'package:awesome_notifications/src/models/model.dart';
import 'package:awesome_notifications/src/utils/assert_utils.dart';
import 'package:awesome_notifications/src/utils/bitmap_utils.dart';
import 'package:awesome_notifications/src/utils/html_utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:io' as io;

import 'notification_icon.dart';

class BaseNotificationContent extends Model {
  int? id;
  String? channelKey;
  String? title;
  String? body;
  String? summary;
  bool? showWhen;
  Map<String, String>? payload;
  String? icon;
  String? largeIcon;
  String? bigPicture;
  String? customSound;
  bool? autoCancel;
  Color? color;
  Color? backgroundColor;
  NotificationPrivacy? privacy;
  IconData? iconData;

  BaseNotificationContent({
    this.id,
    this.channelKey,
    this.title,
    this.body,
    this.summary,
    this.showWhen,
    this.icon,
    this.largeIcon,
    this.bigPicture,
    this.autoCancel,
    this.color,
    this.backgroundColor,
    this.payload,
    this.customSound,
    this.iconData,
  });

  @override
  BaseNotificationContent? fromMap(Map<String, dynamic> mapData) {
    this.id = AssertUtils.extractValue<int>(mapData, 'id');
    this.channelKey = AssertUtils.extractValue<String>(mapData, 'channelKey');
    this.title = AssertUtils.extractValue<String>(mapData, 'title');
    this.body = AssertUtils.extractValue<String>(mapData, 'body');
    this.summary = AssertUtils.extractValue<String>(mapData, 'summary');
    this.showWhen = AssertUtils.extractValue<bool>(mapData, 'showWhen');
    this.payload = AssertUtils.extractMap<String, String>(mapData, 'payload');
    this.icon = AssertUtils.extractValue<String>(mapData, 'icon');
    this.largeIcon = AssertUtils.extractValue<String>(mapData, 'largeIcon');
    this.bigPicture = AssertUtils.extractValue<String>(mapData, 'bigPicture');
    this.customSound = AssertUtils.extractValue<String>(mapData, 'customSound');
    this.autoCancel = AssertUtils.extractValue<bool>(mapData, 'autoCancel');
    this.privacy = AssertUtils.extractEnum<NotificationPrivacy>(
        mapData, 'privacy', NotificationPrivacy.values);

    //Check that only one type of icon is specified
    var logger = Logger(
      printer: PrettyPrinter(
          colors: io.stdout.supportsAnsiEscapes,
          printEmojis: true,
          lineLength: io.stdout.terminalColumns),
    );

    if (this.icon != null && this.icon!.isNotEmpty) {
      assert(this.iconData == null);
      logger.i(this.icon);
    } else if (this.iconData != null) {
      assert(this.icon == null || this.icon!.isEmpty);
      logger.i(this.iconData);
      icon = NotificationIcon().iconDataToDrawableIconName(iconData);
      logger.i(this.icon);
    }

    int? colorValue = AssertUtils.extractValue<int>(mapData, 'color');
    this.color = colorValue == null ? null : Color(colorValue);

    int? backgroundColorValue =
        AssertUtils.extractValue<int>(mapData, 'backgroundColor');
    this.backgroundColor =
        backgroundColorValue == null ? null : Color(backgroundColorValue);

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'channelKey': channelKey,
      'title': title,
      'body': body,
      'summary': summary,
      'showWhen': showWhen,
      'icon': icon,
      'payload': payload,
      'largeIcon': largeIcon,
      'bigPicture': bigPicture,
      'customSound': customSound,
      'autoCancel': autoCancel,
      'privacy': AssertUtils.toSimpleEnumString(privacy),
      'color': color?.value,
      'backgroundColor': backgroundColor?.value
    };
  }

  ImageProvider? get bigPictureImage {
    if (bigPicture?.isEmpty ?? true) return null;
    return BitmapUtils().getFromMediaPath(bigPicture!);
  }

  ImageProvider? get largeIconImage {
    if (largeIcon?.isEmpty ?? true) return null;
    return BitmapUtils().getFromMediaPath(largeIcon!);
  }

  String? get bigPicturePath {
    if (bigPicture?.isEmpty ?? true) return null;
    return BitmapUtils().cleanMediaPath(bigPicture!);
  }

  String? get largeIconPath {
    if (largeIcon?.isEmpty ?? true) return null;
    return BitmapUtils().cleanMediaPath(largeIcon!);
  }

  String? get titleWithoutHtml => HtmlUtils.removeAllHtmlTags(title)!;

  String? get bodyWithoutHtml => HtmlUtils.removeAllHtmlTags(body)!;

  @override
  void validate() {
    assert(!AssertUtils.isNullOrEmptyOrInvalid(id, int));
    assert(!AssertUtils.isNullOrEmptyOrInvalid(channelKey, String));
  }
}
