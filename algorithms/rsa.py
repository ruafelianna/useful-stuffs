# random number from [min, max]
def getRandomNumber(min, max):
    from random import randint
    return randint(min, max)

# a**t % n
# using equality: (a * b) % n = ((a % n) * (b % n)) % n
def powMod(a, t, n):
    r = 1
    while t > 0:
        if t & 1 == 1:
            r = (r * a) % n
        t = t >> 1
        a = (a * a) % n
    return r

# Miller–Rabin primality test
# n - primary => n - 1 = 2**s * t: s, t are integer, t is odd
# k - number of rounds, recommended k = log2(n)
# a - random integer number, 1 < a < n
# k times we are checking if a new for each round a is a primality witness for n
# if it is not then n is composite for sure
# if all a are primality witnesses for n after all rounds then n is probably primary
def checkIsPrimeMillerRabin(n, k):
    t = n - 1
    s = 0
    while not (t & 1):
        t = t >> 1
        s += 1
    for i in range(0, k):
        a = getRandomNumber(2, n - 2)
        x = powMod(a, t, n)
        if (x == 1) or (x == n - 1):
            continue
        continueLoop = False
        for j in range(0, s - 1):
            x = powMod(x, 2, n)
            if x == 1:
                return False
            elif x == n - 1:
                continueLoop = True
                break
        if continueLoop:
            continue
        return False
    return True

# random prime number from [min, max]
# should not be equal to any number from checkNumbers array
def getPrimeNumber(minNum, maxNum, checkNumbers = [-1]):
    from math import log2, floor    
    while True:
        while True:
            testNum = getRandomNumber(minNum, maxNum) | 1
            if testNum not in checkNumbers:
                break
        nSteps = floor(log2(testNum))
        if checkIsPrimeMillerRabin(testNum, nSteps):
            return testNum

# coprime number for f
# choosing e as prime number so we should only check if it is a divisor for f
def getCoprime(f):
    while True:
        e = getPrimeNumber((f >> 1) + 1, f - 1)
        if f % e:
            return e

# Euclid extended algorithm for getting solution for ax + by = d in integer numbers
# d is also gcd for a and b
def getGcdEuclidExt(a, b):
    if not b:
        return a, 1, 0
    else:
        d, x, y = getGcdEuclidExt(b, a % b)
        return d, y, x - y * (a // b)

# modular multiplicative inverse of e % f
# ex + fy = 1 (A)
# (ex + fy) % f = 1 % f
# ex % f = 1, x = modular multiplicative inverse of e % f
# Euclid method also returns negative numbers so we use the following equality for (A):
# x = fN + k: N is integer, k is one of the solutions for x in (A)
def getSecretExp(e, f):
    d, x, y = getGcdEuclidExt(e, f)
    if d != 1:
        raise ValueError('Function arguments are not coprime!')
    while x < 0:
        x += f
    return x

# generating public and private keys for RSA
def getKeys(nBit = 512):
    minNum = 2**(nBit - 1) - 1
    maxNum = 2**nBit - 1
    p = getPrimeNumber(minNum, maxNum)
    q = getPrimeNumber(minNum, maxNum, [p])
    n = p * q
    f = (p - 1) * (q - 1)
    if debug:
        print('p = %x, q = %x, f = %x' % (p, q, f))
    e = getCoprime(f)
    d = getSecretExp(e, f)
    return (e, n), (d, n)

# decoding and encoding message using RSA
def encodeDecodeMessage(msg, key):
    return powMod(msg, key[0], key[1])

# main
debug = False
msg = 11111
nBit = 8
publicKey, privateKey = getKeys(nBit)

while True:
    print('Выберите действие:')
    print('1 - задать сообщение (текущее: %s)' % msg)
    print('2 - создать пару ключей (открытый: (%x, %x), закрытый: (%x, %x))' % (publicKey[0], publicKey[1], privateKey[0], privateKey[1]))
    print('3 - %s отладку' % ('выключить' if debug else 'включить'))
    print('4 - задать размер чисел (сейчас: %d бит)' % nBit)
    print('5 - проверить шифровку/расшифровку')
    print('6 - выход')
    print()
    try:
        action = int(input('Ввод: '))
        if action not in [1, 2, 3, 4, 5, 6]:
            print('Неверный ввод!')
        elif action == 1:
            msg = int(input('Введите сообщение (число): '))
            print('Сообщение изменено')
        elif action == 2:
            publicKey, privateKey = getKeys(nBit)
            print('Ключи сгенерированы')
        elif action == 3:
            debug = not debug
            print('Отладка %s' % ('включена' if debug else 'выключена'))
        elif action == 4:
            nBit = int(input('Количество бит: '))
            print('Значение задано')
        elif action == 5:
            dMsg = encodeDecodeMessage(msg, publicKey)
            eMsg = encodeDecodeMessage(dMsg, privateKey)
            print('Зашифрованное сообщение: %d' % dMsg)
            print('Расшифрованное сообщение: %d' % eMsg)
        elif action == 6:
            print('До новых встреч!')
            break
    except ValueError:
        print('Неверный ввод!')
    print('Нажмите Enter...')
    input()
    print()
