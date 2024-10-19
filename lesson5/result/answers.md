
# Questions

## 1. What is the decimal equivalent of 01001010?

Your Answer:

- Для перевода из двоичной системы в десятичную нужно найти сумму чисел, где каждое число умножить на два в степени разряда этого числа.
- Разряд числа начинается с 0
- ```01001010 = 0*2^7 + 1*2^6 + 0*2^5 + 0*2^4 + 1*2^3 + 0*2^2 + 1*2^1 + 0*2^0 = 64 + 8 + 2 = 74```


## 2. How many subnets and how many hosts in subnet are there for the network address 80.160.0.0/20?

Your Answer:

- Берем 20 бит и получаем значением маски сети
- 11110000 = 240

| 11111111 | 11111111 | 11110000 | 00000000 |
| :------: | :------: | :------: | :------: |
|   255    |   255    |   240    |    0     |


- Nbr subnets = 2^(4) = 16
- Nbr hosts = 2^(12) - 2 = 4094 (12 - число нулевых бит в маске)


## 3. What is the last usable host address of prefix 182.144.10.0/29? 

Your Answer:

| 11111111 | 11111111 | 11111111 | 11111000 |
| :------: | :------: | :------: | :------: |
|   255    |   255    |   255    |   248    |

- Nbr hosts = 2^3 - 2 = 6
- 182.144.10.6 - last usable host


## 4. IP address 10.145.100.6/27 is a part of which host range? 

Your Answer:

| 11111111 | 11111111 | 11111111 | 11100000 |
| :------: | :------: | :------: | :------: |
|   255    |   255    |   255    |   224    |

- Nbr hosts = 2^5 - 2 = 30
- 10.145.100.1-30

## 5. How many IP addresses can be assigned to hosts, for Subnet Mask
255.255.255.0? 

Your Answer:

- Nbr hosts = 2^8 - 2 = 254 - can be assigned to hosts

## 6. If you need to have 5 subnets, which subnet mask do you use? 

Your Answer:

255.255.255.224


## 7. What is the broadcast address of prefix 172.18.16.0/21? 


Your Answer:

| 11111111 | 11111111 | 11111000 | 00000000 |
| :------: | :------: | :------: | :------: |
|   255    |   255    |   248    |    0     |

- Nbr hosts = 2^11 - 2 = 2046
- 2046 + 1 (network) + 1 (broadcast) = 2046
- 2048 / 256 = 8 blocks of ip
- Network #1 172.18.16.0-255
- Network #2 172.18.17.0-255
- Network #3 172.18.18.0-255
- Network #4 172.18.19.0-255
- Network #5 172.18.20.0-255
- Network #6 172.18.21.0-255
- Network #7 172.18.22.0-255
- Network #8 172.18.23.0-255
- 16+8-1 = 23
- broadcast 172.18.23.255