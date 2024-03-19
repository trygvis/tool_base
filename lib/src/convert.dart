// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Hide the original utf8 [Codec] so that we can export our own implementation
// which adds additional error handling.
import 'dart:convert' as cnv show utf8, Utf8Decoder;
import 'dart:convert' hide utf8;

import 'package:tool_base/src/base/common.dart';

export 'dart:convert' hide utf8, Utf8Codec, Utf8Decoder;

/// A [Codec] which reports malformed bytes when decoding.
// Created to solve https://github.com/flutter/flutter/issues/15646.
class Utf8Codec extends Encoding {
  const Utf8Codec();

  @override
  Converter<List<int>, String> get decoder => Utf8Decoder().decoder;

  @override
  Converter<String, List<int>> get encoder => cnv.utf8.encoder;

  @override
  String get name => cnv.utf8.name;
}

Encoding get utf8 => const Utf8Codec();

class Utf8Decoder {
  cnv.Utf8Decoder decoder;

  Utf8Decoder({this.reportErrors = true})
      : decoder = cnv.Utf8Decoder(allowMalformed: true);

  final bool reportErrors;

  String convert(List<int> codeUnits, [int start = 0, int? end]) {
    final String result = decoder.convert(codeUnits, start, end);
    // Finding a unicode replacement character indicates that the input
    // was malformed.
    if (reportErrors && result.contains('\u{FFFD}')) {
      throw ToolExit('Bad UTF-8 encoding found while decoding string: $result. '
          'The Flutter team would greatly appreciate if you could file a bug or leave a'
          'comment on the issue https://github.com/flutter/flutter/issues/15646.\n'
          'The source bytes were:\n$codeUnits\n\n');
    }
    return result;
  }
}
