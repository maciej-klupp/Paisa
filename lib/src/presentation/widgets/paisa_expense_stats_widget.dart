import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa/src/core/common.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'paisa_card.dart';

class PaisaExpenseStatsWidget extends StatelessWidget {
  const PaisaExpenseStatsWidget({
    super.key,
    required this.total,
    required this.title,
    required this.graphLineColor,
    required this.iconData,
    required this.data,
  });

  final List<double> data;
  final Color graphLineColor;
  final IconData iconData;
  final String title;
  final String total;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: PaisaFilledCard(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    maxRadius: 16,
                    backgroundColor: graphLineColor.withOpacity(0.3),
                    child: Icon(
                      iconData,
                      color: graphLineColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.outfit(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.75),
                                  ),
                            ),
                          ),
                          Text(
                            total,
                            style: GoogleFonts.manrope(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Sparkline(
                    data: data,
                    useCubicSmoothing: true,
                    cubicSmoothingFactor: 0.2,
                    lineWidth: 3,
                    lineColor: graphLineColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      tablet: PaisaFilledCard(
        color: context.surfaceVariant.withOpacity(0.4),
        child: ListTile(
          title: Text(
            title,
            style: GoogleFonts.manrope(
              textStyle: context.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.75),
              ),
            ),
          ),
          subtitle: Text(
            total,
            style: GoogleFonts.manrope(
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          leading: Align(
            widthFactor: 0.5,
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              maxRadius: 16,
              backgroundColor: graphLineColor.withOpacity(0.3),
              child: Icon(
                iconData,
                color: graphLineColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
