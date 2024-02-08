import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/utils.dart';
import '../../models/Bussniss_data.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key, this.accountData, this.callback})
      : super(key: key);
  final VoidCallback? callback;
  final BusinessData? accountData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
      child: InkWell(
        onTap: callback,
        splashColor: Colors.transparent,
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: Image.network(
                    '${Utils.baseUrl}/images/${accountData!.serviceImg}',
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        accountData!.serviceName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        accountData!.serviceCity,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        accountData!.serviceType,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        accountData!.serviceNum,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
