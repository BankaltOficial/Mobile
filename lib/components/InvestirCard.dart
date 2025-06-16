import 'package:flutter/material.dart';
import '../service/Colors.dart';

class InvestirCard extends StatelessWidget {
  final String title;
  final String invMin;
  final String resgate;
  final String ir;
  final String tipoAtivo;
  final VoidCallback? onTap;

  const InvestirCard({
    Key? key,
    required this.title,
    required this.invMin,
    required this.resgate,
    required this.ir,
    this.tipoAtivo = '',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.main,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainWhite,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Inv. Mínimo',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mainWhite,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        invMin,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mainWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resgate',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mainWhite,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        resgate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mainWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'I.R.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mainWhite,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        ir,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mainWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (onTap != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.mainWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Toque para investir',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.mainWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}