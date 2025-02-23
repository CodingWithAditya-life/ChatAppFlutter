import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKey() async {
    var scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "aimit-151",
          "private_key_id": "a78785bfeb530198c0d25c6fa64a91284caf9e1a",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCtY1H0ng3PtAbD\ncdD4NWJHCjMtl6cbnsnt2Bk9t7X6XZK7dCky9TMmOAM1aELny65zs36VFhY6Ga/j\neSzFkn+J6UBLw8WgXiH4qXxQ2jzoGTgdJ9duuQqZJg8WehJwgr+fTYo9mouNvg08\nYiucBW0LcNxG/29olFtdEsDHubLQ5BqnWuB9MPPrwUnQE9hbC6weZP5BhyIWHvvT\n5qPBiKoZt22549/w+QihrflDZq9aaT+EDsfxH0qMC1jlY1Ai1vxm7/o1DcF8BRvT\nW1Iqqj6+GCiraG+ggZIEF7G45mVOSRNc88unHLRw9UGT7HlpygazeOXSO826gFTT\nNlvWQM71AgMBAAECggEARahGL6kj0VL4+KIMGvuPbQza/LEVcJI9e7E6isH4eQoI\nvghv2MoLb4pHN7iYUHlSr6bn7ss9yL+zGwb+hq1RUb2EmCuhhMjsivLEP9M9bt1a\n3tO3yALNEDPrEdOe/tZ4V26WYCNrd1loBd9Gt9qyMUt5I4jRYElh3yV+j366KRMh\nNem5PGTOwGHkHiwnE4DF0DzBjY+TE+3lR8ARCf2CXRCA2SELCdn8kP3lxSd2inCA\nEFaMeulY8u1prF9UFMbuVcs1PWf2WDwcWaQ4nN3o/eu3zHomNuDi0sbmfDaKu6QB\nqpV5+w1+qneJLmi+lEoNN6SVfdwymr8MaqlAvxnZLQKBgQDEmgIn116QJwCC1Hgm\nzE4NDMQzQX/UggU2l3MMDHkzstKFXCIama0YFy5qWkoacYGNIerk2UIhaFfmj530\nVPMe+deX6leN9Px+njKhvujkjKOXUh3TmnM7FxM7GRRUtXj3Qod6ezXrrjcqhO54\n27bMXmul+pMriHUtmKw/6XRYkwKBgQDhxd9gFCZO/QivQgA86aTEGCqNWjqJpJ7Z\nR2f3Pv84sYU5Kz8SMY0ejQ+H4VmvSiBKSgpTpz4hdxo0VTJ/B7QiEHewjBkFDwvC\nOdmC5XvQXp8+ybNv+kfEZtdQ/qZeogX0E73v6mvgg8EUF/KqRY3P4HQ8QBGPmv0S\nlF/lpaiXVwKBgH76WVoSJ+lCx3m4cMHeQqr7C91u+HjwYR2ZQ50MkVtqq72mfABi\nMQHWNwxJtILPvLTCq0uTZrrdAajQKVydYUkoZK6hlFsDV/EPi/QbsZ+rlh0t1EXP\nA42uoaUR1afAbZiFR6s72N+XbdnwcXVtsurcMPrKlDMRt1zztoyw44wxAoGAAarY\nb3k2nza3LbQrFEgVc21KQyj7bbDNi4U/e0/3yo9lEHsFSDkddbBNAQ/k/apqeqH5\nWYzOpKighOpsKQwBhI7ik2c1eBgYWiLbPGA9fdh1DJ2ouZb7mLO5u1tmFyTTLm5G\n5NKyYUIX1vImVKOW3IYn1ZoThx/55n06CBQlHpkCgYA1g9pKB8Cxxh2UwR22Zs59\nkZAAIo3JWI6FaFIOztOiKDmi8xvSazhZ1G625WOLq486OPKubrLohenSr4pJ0ZHc\ncNmg2p1XCCshWKvIglwOVyzmLELdrU+gPs4s8b/zQgBk12OIXPQZlMTk7S31+lN0\nJML0lzOdy2m+T1ZNv2G2rQ==\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-s982j@aimit-151.iam.gserviceaccount.com",
          "client_id": "108936194068828667416",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-s982j%40aimit-151.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final serverKey = client.credentials.accessToken.data;
    print("serverKey =$serverKey");
    return serverKey;
  }
}
