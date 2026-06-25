#!/usr/bin/env bash
# Проверка запечатанного prior-art архива. Ключ/пароль НЕ требуется.
set -e
cd "$(dirname "$0")"
F=indicators-prior-art.7z

echo "== 1. SHA-256 архива =="
openssl dgst -sha256 "$F"
echo "  ожидаемый: $(cat "$F.sha256")"

echo
echo "== 2. RFC 3161 (FreeTSA) =="
openssl ts -verify -data "$F" -in "$F.tsr" \
  -CAfile freetsa-cacert.pem -untrusted freetsa-tsa.crt
openssl ts -reply -in "$F.tsr" -text | grep -i "Time stamp"

echo
echo "== 3. OpenTimestamps (Bitcoin) =="
if command -v ots >/dev/null 2>&1; then
  ots upgrade "$F.ots" || true
  ots verify  "$F.ots" || echo "  (ещё pending — повторите позже)"
else
  echo "  установите клиент: pip install opentimestamps-client"
fi
