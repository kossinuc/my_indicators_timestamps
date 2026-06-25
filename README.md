# Prior-art bundle — proprietary trading indicators (sealed)

Этот репозиторий — **запечатанное доказательство существования** набора торговых
индикаторов и стратегий (Pine Script / TradingView) на определённую дату.

Содержимое **зашифровано** (7-Zip, AES-256, с шифрованием имён файлов). Ключ
(passphrase) хранится **только у автора** и в этот репозиторий не входит. Никто,
кроме автора, не может прочитать содержимое — но любой может убедиться, что этот
конкретный зашифрованный файл **существовал не позднее** зафиксированной ниже даты.

Назначение: подтвердить, что данные наработки созданы автором **до** и **вне**
рамок какого-либо договора о разработке (NDA), и потому остаются исключительной
собственностью автора.

---

## Что лежит в репозитории

| Файл | Что это |
|------|---------|
| `indicators-prior-art.7z` | Зашифрованный архив (AES-256, заголовки скрыты). Внутри — индикаторы, стратегии и `manifest.txt` со списком файлов и их SHA-256. |
| `indicators-prior-art.7z.sha256` | SHA-256 зашифрованного архива. |
| `indicators-prior-art.7z.tsr` | RFC 3161 timestamp (ответ доверенного сервера времени FreeTSA). |
| `indicators-prior-art.7z.tsq` | Исходный timestamp-запрос (для воспроизводимости). |
| `indicators-prior-art.7z.ots` | OpenTimestamps-доказательство (якорь в блокчейне Bitcoin). |
| `freetsa-cacert.pem`, `freetsa-tsa.crt` | Сертификаты FreeTSA для проверки RFC 3161. |
| `verify.sh` | Скрипт, прогоняющий все проверки. |

> SHA-256 архива: `82f1bacb0b6fe54429986412508ec73feca268c60d493df61e4deea2bb3d8ca3`
>
> Зафиксированное время (RFC 3161 / FreeTSA): **2026-06-25 09:37:57 GMT**

---

## Как проверить (любой может, ключ не нужен)

### 1. Целостность архива

```bash
sha256sum -c indicators-prior-art.7z.sha256
# или:
openssl dgst -sha256 indicators-prior-art.7z
```

### 2. RFC 3161 timestamp (подпись доверенного сервера времени)

```bash
openssl ts -verify -data indicators-prior-art.7z \
  -in indicators-prior-art.7z.tsr \
  -CAfile freetsa-cacert.pem -untrusted freetsa-tsa.crt
# Ожидается: Verification: OK
```

Просмотреть зафиксированное время:

```bash
openssl ts -reply -in indicators-prior-art.7z.tsr -text | grep "Time stamp"
```

### 3. OpenTimestamps (блокчейн Bitcoin)

```bash
ots upgrade indicators-prior-art.7z.ots   # дотянуть до подтверждённого блока
ots verify  indicators-prior-art.7z.ots   # покажет дату блока Bitcoin
```

> Сразу после создания `.ots` находится в состоянии *pending*: для попадания в
> блок Bitcoin нужно несколько часов. После подтверждения `ots verify` покажет
> реальную дату блока. Файл `.ots` нужно один раз «upgrade» и закоммитить заново.

---

## Доказательство содержимого (только автор)

Содержимое доступно только владельцу passphrase:

```bash
7z x indicators-prior-art.7z          # запросит пароль
```

Внутри — `manifest.txt` со списком всех файлов и их SHA-256 в открытом виде.
Чтобы доказать, что конкретный индикатор входил в запечатанный набор:
расшифровать архив → показать файл → его SHA-256 совпадает со строкой в
`manifest.txt`, а сам архив привязан к дате timestamp'ами выше.

---

## Логическая цепочка доказательства

```
конкретные .pine файлы
   └─(SHA-256, см. manifest внутри архива)
        archive indicators-prior-art.7z
           └─(SHA-256 = 82f1bacb…)
                ├─ RFC 3161 (FreeTSA)      → подпись на 2026-06-25 09:37:57 GMT
                └─ OpenTimestamps (Bitcoin) → блок с датой ≤ момента подтверждения
```

Подделать дату нельзя: ни FreeTSA, ни блокчейн Bitcoin автор не контролирует.
Следовательно, архив (а с ним и все индикаторы) существовал **не позднее**
указанной даты.
