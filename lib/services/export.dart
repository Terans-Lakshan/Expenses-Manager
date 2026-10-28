import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/database.dart';
import '../domain/calculations.dart';
import '../domain/money.dart';
import '../domain/period.dart';

/// CSV in the PRD format:
/// `date,time,type,category,amount,wallet,note`
String recordsToCsv(List<TxRow> records, Map<int, CategoryRow> cats, Map<int, WalletRow> wallets) {
  final b = StringBuffer('date,time,type,category,amount,wallet,note\r\n');
  final date = DateFormat('yyyy-MM-dd'), time = DateFormat('HH:mm');
  for (final r in records) {
    b.writeAll([
      date.format(r.occurredAt),
      time.format(r.occurredAt),
      r.type,
      _csv(cats[r.categoryId]?.name ?? ''),
      (r.amountCents / 100).toStringAsFixed(2),
      _csv(wallets[r.walletId]?.name ?? ''),
      _csv(r.note ?? ''),
    ], ',');
    b.write('\r\n');
  }
  return b.toString();
}

String _csv(String v) {
  // Guard against spreadsheet formula injection, then quote if needed.
  var s = v;
  if (s.isNotEmpty && '=+-@'.contains(s[0])) s = "'$s";
  if (s.contains(RegExp(r'[",\r\n]'))) s = '"${s.replaceAll('"', '""')}"';
  return s;
}

/// UTF-8 with BOM so Excel opens non-ASCII text correctly.
Uint8List csvBytes(String csv) => Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(csv)]);

const _ink = PdfColor.fromInt(0xFF0F1B2D);
const _muted = PdfColor.fromInt(0xFF5A6575);
const _income = PdfColor.fromInt(0xFF1D5FCC);
const _expense = PdfColor.fromInt(0xFFB4471A);
const _divider = PdfColor.fromInt(0xFFEEF1F4);

/// PDF list of records with totals for [range].
Future<Uint8List> recordsToPdf({
  required List<TxRow> records,
  required Map<int, CategoryRow> cats,
  required Map<int, WalletRow> wallets,
  required DateRange range,
  required Money money,
}) async {
  final doc = pw.Document(title: 'Expense Manager records');
  final totals = totalsOf(records);
  final df = DateFormat('d MMM y, HH:mm');
  // Built-in PDF fonts have no "−" or "₹" glyphs, so use ASCII signs.
  String m(int c) => _ascii(money.format(c));
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    build: (c) => [
      pw.Text('Records', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: _ink)),
      pw.SizedBox(height: 4),
      pw.Text(periodLabel(PeriodKind.custom, range), style: const pw.TextStyle(color: _muted)),
      pw.SizedBox(height: 16),
      _summary([
        ('Income', m(totals.incomeCents), _income),
        ('Expenses', m(totals.expenseCents), _expense),
        ('Net', m(totals.netCents), _ink),
      ]),
      pw.SizedBox(height: 16),
      if (records.isEmpty)
        pw.Text('No records in this range.', style: const pw.TextStyle(color: _muted))
      else
        pw.TableHelper.fromTextArray(
          headers: ['Date', 'Type', 'Category', 'Wallet', 'Note', 'Amount'],
          data: [
            for (final r in records)
              [
                df.format(r.occurredAt),
                r.type == typeIncome ? 'Income' : 'Expense',
                _ascii(cats[r.categoryId]?.name ?? ''),
                _ascii(wallets[r.walletId]?.name ?? ''),
                _ascii(r.note ?? ''),
                '${r.type == typeIncome ? '+' : '-'}${m(r.amountCents)}',
              ],
          ],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: _ink, fontSize: 9),
          cellStyle: const pw.TextStyle(fontSize: 9, color: _ink),
          headerDecoration: const pw.BoxDecoration(color: _divider),
          cellAlignments: {5: pw.Alignment.centerRight},
          border: null,
          rowDecoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: _divider, width: 0.5))),
        ),
    ],
  ));
  return doc.save();
}

/// PDF of the Reports screen: summary, income vs expenses table and category breakdown.
Future<Uint8List> reportToPdf({
  required String title,
  required String rangeLabel,
  required Totals totals,
  required List<BarBucket> buckets,
  required List<(String, int, int)> breakdown, // name, cents, percent
  required Money money,
}) async {
  final doc = pw.Document(title: 'Expense Manager report');
  String m(int c) => _ascii(money.format(c));
  final saved = savedPercent(totals);
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    build: (c) => [
      pw.Text(title, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: _ink)),
      pw.SizedBox(height: 4),
      pw.Text(rangeLabel, style: const pw.TextStyle(color: _muted)),
      pw.SizedBox(height: 16),
      _summary([
        ('Income', m(totals.incomeCents), _income),
        ('Expenses', m(totals.expenseCents), _expense),
        saved == null
            ? ('Overspent', m(totals.netCents.abs()), _expense)
            : ('Saved', '$saved%', _ink),
      ]),
      pw.SizedBox(height: 20),
      pw.Text('Income vs expenses', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: _ink)),
      pw.SizedBox(height: 8),
      pw.TableHelper.fromTextArray(
        headers: ['Period', 'Income', 'Expenses', 'Net'],
        data: [
          for (final b in buckets)
            [
              periodLabel(PeriodKind.custom, b.range),
              m(b.incomeCents),
              m(b.expenseCents),
              m(b.incomeCents - b.expenseCents),
            ],
        ],
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: _ink, fontSize: 10),
        cellStyle: const pw.TextStyle(fontSize: 10, color: _ink),
        headerDecoration: const pw.BoxDecoration(color: _divider),
        cellAlignments: {1: pw.Alignment.centerRight, 2: pw.Alignment.centerRight, 3: pw.Alignment.centerRight},
        border: null,
      ),
      pw.SizedBox(height: 20),
      pw.Text('Where the money went', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: _ink)),
      pw.SizedBox(height: 8),
      if (breakdown.isEmpty)
        pw.Text('No expenses in this period.', style: const pw.TextStyle(color: _muted))
      else
        pw.TableHelper.fromTextArray(
          headers: ['Category', 'Share', 'Amount'],
          data: [for (final (n, cents, pct) in breakdown) [_ascii(n), '$pct%', m(cents)]],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: _ink, fontSize: 10),
          cellStyle: const pw.TextStyle(fontSize: 10, color: _ink),
          headerDecoration: const pw.BoxDecoration(color: _divider),
          cellAlignments: {1: pw.Alignment.centerRight, 2: pw.Alignment.centerRight},
          border: null,
        ),
    ],
  ));
  return doc.save();
}

pw.Widget _summary(List<(String, String, PdfColor)> items) => pw.Row(children: [
      for (final (label, value, color) in items)
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.only(right: 8),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
                color: const PdfColor.fromInt(0xFFF2F4F7), borderRadius: pw.BorderRadius.circular(8)),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: _muted)),
              pw.SizedBox(height: 2),
              pw.Text(value, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: color)),
            ]),
          ),
        ),
    ]);

/// The standard PDF Helvetica font only covers Latin-1.
String _ascii(String s) => s
    .replaceAll('−', '-')
    .replaceAll('–', '-')
    .replaceAll('₹', 'INR ')
    .replaceAll('€', 'EUR ')
    .replaceAll(RegExp(r'[^\x00-\xFF]'), '?');
